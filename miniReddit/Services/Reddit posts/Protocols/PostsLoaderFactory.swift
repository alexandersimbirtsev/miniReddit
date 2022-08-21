
protocol PostsLoaderFactory {
    func makeUnauthorizedPostsLoader() -> PostsLoader
    func makeAuthorizedPostsLoader() -> PostsLoader
}
