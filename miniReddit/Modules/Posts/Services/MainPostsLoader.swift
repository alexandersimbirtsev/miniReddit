
final class MainPostsLoader {
    private let postsLoader: PostsLoader
    
    init(postsLoader: PostsLoader) {
        self.postsLoader = postsLoader
    }
}

//MARK: - PostsModelLoader
extension MainPostsLoader: PostsModelLoader {
    func getPosts(after: String?, completion: @escaping (Result<[PostsCellModel], Error>) -> Void) {
        postsLoader.loadPosts(subreddit: "cats", after: after) { result in
            switch result {
            case .success(let posts):
                let newPosts = posts.compactMap(PostsCellModel.init)
                completion(.success(newPosts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
