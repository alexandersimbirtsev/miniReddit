
final class NetworkRedditTokensRetriever {
    private let dataLoader  : URLRequestDataLoader
    private let requestMaker: RedditTokensRequestMaker
    private let decoder     : RedditTokensDecoder

    init(
        dataLoader  : URLRequestDataLoader,
        requestMaker: RedditTokensRequestMaker,
        decoder     : RedditTokensDecoder
    ) {
        self.dataLoader   = dataLoader
        self.requestMaker = requestMaker
        self.decoder      = decoder
    }
}

//MARK: - RedditTokensRetriever
extension NetworkRedditTokensRetriever: RedditTokensRetriever {
    func getTokens(with parameter: String, completion: @escaping (Result<RedditTokens, Swift.Error>) -> Void) {
        guard let request = requestMaker.makeURLRequest(with: parameter) else {
            completion(.failure(Error.request))
            return
        }
        
        dataLoader.loadData(request: request) { [weak self] data, response, error in
            if let _ = error {
                return completion(.failure(Error.get))
            }

            guard let data = data else {
                return completion(.failure(Error.get))
            }

            guard let tokens = self?.decoder.decode(from: data) else {
                return completion(.failure(Error.decode))
            }

            return completion(.success(tokens))
        }
    }
}

//MARK: - Error
private extension NetworkRedditTokensRetriever {
    typealias Error = NetworkRedditTokensRetrieverError
    
    enum NetworkRedditTokensRetrieverError: Swift.Error {
        case request
        case get
        case decode
    }
}
