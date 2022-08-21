
final class RedditAccountProviderFactory {
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

//MARK: - RedditAccountProviderFactory
extension RedditAccountProviderFactory: AccountProviderFactory {
    func makeAuthorizedAccountProvider() -> AccountProvider {
        let meLoader = NetworkMeLoader(
            dataLoader   : dependencies.authorizedDataLoader,
            sessionMaker : dependencies.authorizedURLSessionMaker,
            tokensStorage: dependencies.tokensStorage,
            decoder      : RedditUserDecoderFromJSON(),
            request      : dependencies.redditAPI.makeMeURLRequest()
        )
        let provider = MainAccountProvider(
            meLoader: meLoader,
            dataLoader: NetworkURLDataLoader(session: .shared)
        )
        
        return provider
    }
    
    func makeUnauthorizedAccountProvider() -> AccountProvider {
        UnauthorizedAccountProvider()
    }
}
