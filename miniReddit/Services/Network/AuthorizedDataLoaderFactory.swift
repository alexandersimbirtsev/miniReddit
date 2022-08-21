
final class AuthorizedDataLoaderFactory {
    private unowned let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

//MARK: - URLSessionRequestDataLoaderFactory
extension AuthorizedDataLoaderFactory: URLSessionRequestDataLoaderFactory {
    
    func createAuthorized() -> URLSessionRequestDataLoader {
        let fallbackSession = dependencies.redditAuthenticationService.makeURLSession()
        let requestMaker = AuthorizedRedditRefreshTokensRequestMaker(authenticationService: dependencies.redditAuthenticationService)
        
        let tokensRetriever = NetworkRedditTokensRetriever(
            dataLoader  : NetworkURLRequestDataLoader(session: fallbackSession),
            requestMaker: requestMaker,
            decoder     : RedditTokensDecoderWithJSON()
        )
        let dataLoaderUnauthorizedFallback = RedditUnauthorizedFallbackDataLoader(
            tokensRetriever: tokensRetriever,
            sessionMaker   : dependencies.authorizedURLSessionMaker,
            tokensStorage  : dependencies.tokensStorage
        )
        let dataLoader = NetworkURLSessionRequestDataLoader()
            .unauthorizedFallback(dataLoaderUnauthorizedFallback)
        
        return dataLoader
    }
}
