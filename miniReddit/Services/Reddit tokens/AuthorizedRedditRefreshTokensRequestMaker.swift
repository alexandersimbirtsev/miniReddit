
import Foundation

final class AuthorizedRedditRefreshTokensRequestMaker {
    private let authenticationService: RedditAuthentication
    
    init(authenticationService: RedditAuthentication) {
        self.authenticationService = authenticationService
    }
}

//MARK: - RedditTokensRequestMaker
extension AuthorizedRedditRefreshTokensRequestMaker: RedditTokensRequestMaker {
    func makeURLRequest(with parameter: String) -> URLRequest? {
        authenticationService.makeRefreshTokensURLRequest(with: parameter)
    }
}
