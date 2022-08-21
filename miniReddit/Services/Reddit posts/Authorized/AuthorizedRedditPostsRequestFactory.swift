
import Foundation

final class AuthorizedRedditPostsRequestMaker {
    private let redditAPI: RedditAPI
    
    init(redditAPI: RedditAPI) {
        self.redditAPI = redditAPI
    }
}

//MARK: - RedditPostsRequestMaker
extension AuthorizedRedditPostsRequestMaker: RedditPostsRequestMaker {
    func makeURLRequest(subreddit: String, after: String?) -> URLRequest? {
        redditAPI.makeAuthorizedPostsURLRequest(subreddit: subreddit, afterID: after)
    }
}
