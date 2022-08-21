
import Foundation

protocol RedditAuthentication: AnyObject {
    func makeURLSession() -> URLSession
    func makeAuthenticationURL() -> URL?
    func makeAccessCodeFromCallback(_ url: URL) -> String?
    func makeGetTokensURLRequest(with accessCode: String) -> URLRequest?
    func makeRefreshTokensURLRequest(with refreshToken: String) -> URLRequest?
}
