
import Foundation

final class NetworkMeLoader {
    private let dataLoader   : URLSessionRequestDataLoader
    private let sessionMaker : URLSessionMaker
    private let tokensStorage: RedditTokensSecureStorage
    private let decoder      : RedditUserDecoder
    private let request      : URLRequest?
    
    init(
        dataLoader   : URLSessionRequestDataLoader,
        sessionMaker : URLSessionMaker,
        tokensStorage: RedditTokensSecureStorage,
        decoder      : RedditUserDecoder,
        request      : URLRequest?
    ) {
        self.dataLoader    = dataLoader
        self.sessionMaker  = sessionMaker
        self.tokensStorage = tokensStorage
        self.decoder       = decoder
        self.request       = request
    }
}

//MARK: - MeLoader
extension NetworkMeLoader: MeLoader {
    func load(completion: @escaping (Result<RedditUser, Swift.Error>) -> Void) {
        
        guard let request = request else {
            completion(.failure(Error.request))
            return
        }
        
        guard let accessToken = tokensStorage.get()?.accessToken else {
            completion(.failure(Error.token))
            return
        }
        
        let session = sessionMaker.makeURLSession(with: accessToken)
        
        dataLoader.loadData(with: session, request: request) { [weak self] data, _, error in
            if let _ = error {
                return completion(.failure(Error.get))
            }
            
            guard let data = data else {
                return completion(.failure(Error.get))
            }
            
            guard let user = self?.decoder.decode(from: data) else {
                return completion(.failure(Error.decode))
            }
            
            return completion(.success(user))
        }
    }
}

//MARK: - Error
private extension NetworkMeLoader {
    typealias Error = NetworkMeLoaderError
    
    enum NetworkMeLoaderError: Swift.Error {
        case request
        case token
        case get
        case decode
    }
}
