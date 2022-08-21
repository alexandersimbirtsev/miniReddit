
import Foundation

protocol RedditPostsRequestMaker {
    func makeURLRequest(subreddit: String, after: String?) -> URLRequest?
}
