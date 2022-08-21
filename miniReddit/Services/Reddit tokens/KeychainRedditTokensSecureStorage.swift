
final class KeychainRedditTokensSecureStorage {
    private let secureStorage: SecureStorage
    private let coder        : RedditTokensCoder
    private let tokensKey    : String
    
    init(
        secureStorage: SecureStorage,
        coder        : RedditTokensCoder,
        tokensKey    : String
    ) {
        self.secureStorage = secureStorage
        self.coder         = coder
        self.tokensKey     = tokensKey
    }
}

//MARK: - RedditTokensSecureStorage
extension KeychainRedditTokensSecureStorage: RedditTokensSecureStorage {
    func save(_ tokens: RedditTokens) {
        guard let data = coder.encode(tokens) else { return }
        
        try? secureStorage.add(
            data,
            forKey: tokensKey)
    }
    
    func get() -> RedditTokens? {
        guard let data = secureStorage.get(byKey: tokensKey) else { return nil }
        
        return coder.decode(from: data)
    }
    
    func remove() {
        try? secureStorage.remove(byKey: tokensKey)
    }
}
