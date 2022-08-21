
import Foundation

final class AuthorizedRedditTokensRequestMaker {
    private let authenticationService: RedditAuthentication
    
    init(authenticationService: RedditAuthentication) {
        self.authenticationService = authenticationService
    }
}

//MARK: - RedditTokensRequestMaker
extension AuthorizedRedditTokensRequestMaker: RedditTokensRequestMaker {
    func makeURLRequest(with parameter: String) -> URLRequest? {
        authenticationService.makeGetTokensURLRequest(with: parameter)
    }
}
