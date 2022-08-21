
import Foundation

final class ConcurrentDataLoader<LoadOperation: Operation & OperationOutput> where LoadOperation.Output == Data {
    
    private let cache: URLDataCacheable
    private let makeOperation: (URL) -> LoadOperation
    
    private let queue = OperationQueue()
    private var operations = [URL: LoadOperation]()
    
    private let serialAccessQueue: OperationQueue = {
        let serialAccessQueue = OperationQueue()
        serialAccessQueue.maxConcurrentOperationCount = 1
        return serialAccessQueue
    }()
    
    init(
        cache: URLDataCacheable,
        makeOperation: @escaping (URL) -> LoadOperation
    ) {
        self.cache = cache
        self.makeOperation = makeOperation
    }
    
    private func makeSuccessLoadingCompletion(
        url: URL,
        operation: LoadOperation,
        completion: ((Data) -> Void)? = nil
    ) -> () -> Void {
        return { [weak operation] in
            guard let data = operation?.output else { return }
            
            self.cache.save(data, for: url)
            
            self.serialAccessQueue.addOperation {
                self.operations.removeValue(forKey: url)
            }
            completion?(data)
        }
    }
    
    private func getDataFromCache(with url: URL) -> Data? {
        return cache.get(from: url)
    }
}

//MARK: - ConcurrentLoader
extension ConcurrentDataLoader: ConcurrentLoader {
    func getData(with url: URL, completion: @escaping (Data) -> Void) {
        serialAccessQueue.addOperation {
            if let data = self.getDataFromCache(with: url) {
                completion(data)
                return
            }

            if let operation = self.operations[url] {

                // If operation exists
                if let data = operation.output {

                    completion(data)

                    self.operations.removeValue(forKey: url)
                } else {
                    operation.completionBlock = { [weak operation] in
                        guard let data = operation?.output else { return }

                        completion(data)

                        self.serialAccessQueue.addOperation {
                            self.operations.removeValue(forKey: url)
                        }
                    }
                }

                // If operation is not created yet
            } else {
                let operation = self.makeOperation(url)
                operation.completionBlock = self.makeSuccessLoadingCompletion(
                    url       : url,
                    operation : operation,
                    completion: completion
                )
                self.queue.addOperation(operation)

                self.operations[url] = operation
            }
        }
    }
    
    func start(with url: URL) {
        serialAccessQueue.addOperation {
            guard self.operations[url] == nil else { return }
            guard self.getDataFromCache(with: url) == nil else { return }
            
            let operation = self.makeOperation(url)
            operation.completionBlock = self.makeSuccessLoadingCompletion(
                url: url,
                operation: operation
            )
            self.queue.addOperation(operation)
            
            self.operations[url] = operation
        }
    }
    
    func stop(with url: URL) {
        serialAccessQueue.addOperation {
            guard let operation = self.operations[url] else { return }
            
            operation.cancel()
            
            self.operations.removeValue(forKey: url)
        }
    }
}
