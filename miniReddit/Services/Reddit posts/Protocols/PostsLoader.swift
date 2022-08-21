
import Foundation

protocol PostsLoader {
    func loadPosts(
        subreddit: String,
        after: String?,
        completion: @escaping (Result<[RedditPost], Error>) -> Void
    )
}
