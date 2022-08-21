
import Foundation

final class RedditAuthenticationService {
    private let configuration: AuthenticationConfiguration
    
    init(configuration: AuthenticationConfiguration) {
        self.configuration = configuration
    }
}

//MARK: - RedditAuthentication
extension RedditAuthenticationService: RedditAuthentication {
    
    //MARK: - Authentication URL
    func makeAuthenticationURL() -> URL? {
        let parameters: [String : String] = [
            "client_id"    : configuration.clientID,
            "response_type": configuration.responseType,
            "state"        : configuration.apiState,
            "redirect_uri" : configuration.redirectURI,
            "duration"     : configuration.duration,
            "scope"        : configuration.scope
        ]
        return URL(
            scheme    : configuration.scheme,
            host      : configuration.host,
            path      : Method.authentication.path,
            parameters: parameters
        )
    }

    //MARK: - Access token parsing
    func makeAccessCodeFromCallback(_ url: URL) -> String? {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        
        guard
            let codeState = queryItems?
                .filter({ $0.name == "state" })
                .first?
                .value,
            codeState == configuration.apiState,
            let code = queryItems?
                .filter({ $0.name == "code" })
                .first?
                .value
        else { return nil }

        return code
    }

    //MARK: - Get tokens
    func makeGetTokensURLRequest(with accessCode: String) -> URLRequest? {
        guard let url = makeGetTokensURL() else { return nil }
        
        let parameters = [
            "grant_type"  : "authorization_code",
            "code"        : accessCode,
            "redirect_uri": configuration.redirectURI
        ]
        return URLRequest(
            url       : url,
            method    : .post,
            parameters: parameters,
            timeout   : 5
        )
    }
    
    //MARK: - Refresh tokens
    func makeRefreshTokensURLRequest(with refreshToken: String) -> URLRequest? {
        guard let url = makeRefreshTokensURL() else { return nil }
        
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]

        return URLRequest(
            url       : url,
            method    : .post,
            parameters: parameters,
            timeout   : 5
        )
    }
    
    //MARK: - Make URL Session
    func makeURLSession() -> URLSession {
        let header        = makeAuthorizationHeader()
        let configuration = makeURLSessionConfiguration(withHeader: header)
        let session       = URLSession(configuration: configuration)

        return session
    }
}

//MARK: - Helpers
private extension RedditAuthenticationService {
    private func makeAuthorizationHeader() -> String {
        let clientIDStringBase64Encoded = "\(configuration.clientID):"
            .data(using: .utf8)?
            .base64EncodedString()

        return "Basic \(clientIDStringBase64Encoded ?? "")"
    }
    
    private func makeURLSessionConfiguration(withHeader header: String) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        let headers = ["Authorization": header]

        configuration.httpAdditionalHeaders = headers
        configuration.waitsForConnectivity = true

        return configuration
    }

    private func makeGetTokensURL() -> URL? {
        URL(
            scheme: configuration.scheme,
            host  : configuration.host,
            path  : Method.tokens.path
        )
    }
    
    private func makeRefreshTokensURL() -> URL? {
        URL(
            scheme    : configuration.scheme,
            host      : configuration.host,
            path      : Method.refreshTokens.path,
            parameters: nil
        )
    }
}

//MARK: - Method
private extension RedditAuthenticationService {
    private enum Method {
        case tokens
        case authentication
        case refreshTokens
        
        var path: String {
            switch self {
            case .tokens, .refreshTokens:
                return "/api/v1/access_token"
            case .authentication:
                return "/api/v1/authorize.compact"
            }
        }
    }
}
