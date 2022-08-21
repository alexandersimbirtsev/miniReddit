
final class MainPostsLoaderFactory {
    private let dependencies: Dependencies
    private let postsDecoder: PostsDecoder
    
    init(
        dependencies: Dependencies,
        postsDecoder: PostsDecoder
    ) {
        self.dependencies = dependencies
        self.postsDecoder = postsDecoder
    }
}

//MARK: - PostsLoaderFactory
extension MainPostsLoaderFactory: PostsLoaderFactory {
    
    func makeUnauthorizedPostsLoader() -> PostsLoader {
        UnauthorizedPostsLoader(
            requestMaker     : UnauthorizedRedditPostsRequestMaker(redditAPI: dependencies.redditAPI),
            networkDataLoader: NetworkURLRequestDataLoader(session: .shared),
            decoder          : postsDecoder
        )
    }
    
    func makeAuthorizedPostsLoader() -> PostsLoader {
        AuthorizedPostsLoader(
            dataLoader   : dependencies.authorizedDataLoader,
            sessionMaker : dependencies.authorizedURLSessionMaker,
            requestMaker : AuthorizedRedditPostsRequestMaker(redditAPI: dependencies.redditAPI),
            tokensStorage: dependencies.tokensStorage,
            decoder      : postsDecoder
        )
    }
}
