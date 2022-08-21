
final class NetworkRedditTokensRetrieverOperation<Input: OperationOutput>: AsyncOperation, OperationOutput where Input.Output == String {
    private let tokensRetriever: RedditTokensRetriever
    
    var output: RedditTokens?
    
    init(tokensRetriever: RedditTokensRetriever) {
        self.tokensRetriever = tokensRetriever
    }
    
    override func main() {
        if isCancelled { return }
        
        guard
            let inputOperation = dependencies
                .compactMap( { $0 as? Input })
                .first,
            let accessCode = inputOperation.output
        else { return }
        
        tokensRetriever.getTokens(with: accessCode) { result in
            if self.isCancelled { return }

            if case .success(let tokens) = result {
                self.output = tokens
            }

            self.state = .finished
        }
    }
}
