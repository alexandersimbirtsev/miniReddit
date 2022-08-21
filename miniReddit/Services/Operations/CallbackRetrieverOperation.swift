
import Foundation

final class CallbackRetrieverOperation: AsyncOperation, OperationOutput {
    private let callbackRetriever: URLCallbackRetriever
    
    var output: URL?
    
    init(callbackRetriever: URLCallbackRetriever) {
        self.callbackRetriever = callbackRetriever
    }
    
    override func main() {
        if isCancelled { return }
        
        callbackRetriever.makeCallback { result in
            if self.isCancelled { return }
            
            if case .success(let url) = result {
                self.output = url
            }
            self.state = .finished
        }
    }
}
