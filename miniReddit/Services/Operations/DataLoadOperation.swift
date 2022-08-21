
import Foundation

final class DataLoadOperation: AsyncOperation, OperationOutput {
    private let url: URL
    private let dataLoader: URLDataLoader
    
    var output: Data?
    
    init(url: URL, dataLoader: URLDataLoader) {
        self.url = url
        self.dataLoader = dataLoader
    }
    
    override func main() {
        if isCancelled { return }
        
        dataLoader.loadData(url: url) { data, response, error in
            if self.isCancelled { return }
            
            if let data = data {
                self.output = data
            }
            self.state = .finished
        }
    }
}
