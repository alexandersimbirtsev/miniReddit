
import AuthenticationServices

final class AuthenticationCallbackRetriever: NSObject {
    private let url: URL
    private let scheme: String
    
    init(url: URL, scheme: String) {
        self.url = url
        self.scheme = scheme
    }
}

//MARK: - ASWebAuthenticationPresentationContextProviding
extension AuthenticationCallbackRetriever: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

//MARK: - URLCallbackRetriever
extension AuthenticationCallbackRetriever: URLCallbackRetriever {
    func makeCallback(completion: @escaping (Result<URL, Swift.Error>) -> Void) {
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
            if let url = callbackURL {
                completion(.success(url))
            } else {
                completion(.failure(Error.callback))
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
}

//MARK: - Error
private extension AuthenticationCallbackRetriever {
    typealias Error = AuthenticationCallbackRetrieverError
    
    enum AuthenticationCallbackRetrieverError: Swift.Error {
        case callback
    }
}
