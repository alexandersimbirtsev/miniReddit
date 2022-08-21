
import Foundation

final class AccessCodeFromCallbackRetrieverOperation: AsyncOperation, OperationOutput {
    private let callback: URL
    private let accessCodeRetriever: AccessCodeRetriever
    
    var output: String?
    
    init(
        callback: URL,
        accessCodeRetriever: AccessCodeRetriever
    ) {
        self.callback = callback
        self.accessCodeRetriever = accessCodeRetriever
    }
    
    override func main() {
        if isCancelled { return }
        
        accessCodeRetriever.makeAccessCode(from: callback) { result in
            if self.isCancelled { return }

            if case .success(let accessCode) = result {
                self.output = accessCode
            }

            self.state = .finished
        }
    }
}
