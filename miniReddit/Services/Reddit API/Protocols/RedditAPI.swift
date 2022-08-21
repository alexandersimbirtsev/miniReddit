
import Foundation

protocol RedditAPI {
    // Me
    func makeMeURLRequest() -> URLRequest?
    // Authorized posts
    func makeAuthorizedPostsURLRequest(subreddit: String, afterID: String?) -> URLRequest?
    // Posts
    func makePostsURLRequest(subreddit: String, afterID: String?) -> URLRequest?
    // Session
    func makeSession(withHeader header: String) -> URLSession
    // Unauthorized session
    func makeUnauthorizedSession() -> URLSession
}
