
import Foundation

final class RedditAuthorizedURLSessionMaker {
    private let redditAPI: RedditAPI
    
    init(redditAPI: RedditAPI) {
        self.redditAPI = redditAPI
    }
}

//MARK: - RedditURLSessionMaker
extension RedditAuthorizedURLSessionMaker: URLSessionMaker {
    func makeURLSession(with parameter: String) -> URLSession {
        redditAPI.makeSession(withHeader: parameter)
    }
}
