
final class KeychainRedditTokensSecureStorageOperation<Input: OperationOutput>: AsyncOperation where Input.Output == RedditTokens {
    private let secureStorage: RedditTokensSecureStorage
    
    init(secureStorage: RedditTokensSecureStorage) {
        self.secureStorage = secureStorage
    }
    
    override func main() {
        if isCancelled { return }
        
        guard
            let inputOperation = dependencies
                .compactMap( { $0 as? Input })
                .first,
            let tokens = inputOperation.output
        else { return }
        
        secureStorage.save(tokens)
        
        self.state = .finished
    }
}
