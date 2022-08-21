
import Foundation

final class RedditUnauthorizedFallbackDataLoader {
    private let tokensRetriever: RedditTokensRetriever
    private let sessionMaker   : URLSessionMaker
    private let tokensStorage  : RedditTokensSecureStorage

    init(
        tokensRetriever: RedditTokensRetriever,
        sessionMaker   : URLSessionMaker,
        tokensStorage  : RedditTokensSecureStorage
    ) {
        self.tokensRetriever = tokensRetriever
        self.sessionMaker    = sessionMaker
        self.tokensStorage   = tokensStorage
    }
}

//MARK: - URLSessionRequestDataLoader
extension RedditUnauthorizedFallbackDataLoader: URLSessionRequestDataLoader {
    func loadData(
        with session: URLSession,
        request     : URLRequest,
        completion  : @escaping (Data?, URLResponse?, Swift.Error?) -> Void
    ) {

        guard let refreshToken = tokensStorage.get()?.refreshToken else {
            completion(nil, nil, Error.getToken)
            return
        }

        // Refresh tokens
        tokensRetriever.getTokens(with: refreshToken) { [weak self] result in
            switch result {
            case .success(let tokens):

                // Saving new tokens to secure storage
                self?.tokensStorage.save(tokens)

                // Make new session with updated access token
                guard let newSession = self?.sessionMaker.makeURLSession(with: tokens.accessToken) else {
                    completion(nil, nil, Error.session)
                    return
                }

                // Make new task with old request
                newSession
                    .dataTask(with: request, completionHandler: completion)
                    .resume()

            case .failure:
                completion(nil, nil, Error.refreshToken)
            }
        }
    }
}

//MARK: - Error
private extension RedditUnauthorizedFallbackDataLoader {
    typealias Error = RedditUnauthorizedFallbackDataLoaderError
    
    enum RedditUnauthorizedFallbackDataLoaderError: Swift.Error {
        case getToken
        case refreshToken
        case session
    }
}
