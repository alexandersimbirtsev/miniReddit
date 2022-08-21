
import Foundation

final class MainPostsProvider {
    private let postsLoader: PostsModelLoader
    
    var rows: [PostsCellModel] = []
    
    init(postsLoader: PostsModelLoader) {
        self.postsLoader = postsLoader
    }
}

//MARK: - PostsProvider
extension MainPostsProvider: PostsProvider {
    func loadRows(after: String?, completion: (() -> Void)?) {
        postsLoader.getPosts(after: after) { result in
            if case .success(let newPosts) = result {
                DispatchQueue.main.async {
                    if after == nil {
                        self.rows = newPosts
                    } else {
                        self.rows += newPosts
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
