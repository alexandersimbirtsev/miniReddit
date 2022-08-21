
import Foundation

final class UnauthorizedRedditPostsRequestMaker {
    private let redditAPI: RedditAPI
    
    init(redditAPI: RedditAPI) {
        self.redditAPI = redditAPI
    }
}

//MARK: - RedditPostsRequestMaker
extension UnauthorizedRedditPostsRequestMaker: RedditPostsRequestMaker {
    func makeURLRequest(subreddit: String, after: String?) -> URLRequest? {
        redditAPI.makePostsURLRequest(subreddit: subreddit, afterID: after)
    }
}
