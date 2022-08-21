
@testable import miniReddit
import Foundation

class MockedPostsLoader: PostsLoader {
    
    var returnPosts = true
    var posts: [RedditPost] = []
    
    func loadPosts(
        subreddit: String,
        after: String?,
        completion: @escaping (Result<[RedditPost], Error>) -> Void
    ) {
        if returnPosts {
            
            if let _ = after {
                completion(.success(posts + posts))
            } else {
                completion(.success(posts))
            }
        } else {
            completion(.failure(TestError()))
        }
    }
}
