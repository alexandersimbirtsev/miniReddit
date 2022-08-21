
import Foundation

final class AuthorizedPostsLoader {
    private let dataLoader   : URLSessionRequestDataLoader
    private let sessionMaker : URLSessionMaker
    private let requestMaker : RedditPostsRequestMaker
    private let tokensStorage: RedditTokensSecureStorage
    private let decoder      : PostsDecoder

    init(
        dataLoader   : URLSessionRequestDataLoader,
        sessionMaker : URLSessionMaker,
        requestMaker : RedditPostsRequestMaker,
        tokensStorage: RedditTokensSecureStorage,
        decoder      : PostsDecoder
    ) {
        self.dataLoader    = dataLoader
        self.sessionMaker  = sessionMaker
        self.requestMaker  = requestMaker
        self.tokensStorage = tokensStorage
        self.decoder       = decoder
    }
}

//MARK: - PostsLoader
extension AuthorizedPostsLoader: PostsLoader {
    func loadPosts(subreddit: String, after: String?, completion: @escaping (Result<[RedditPost], Swift.Error>) -> Void) {

        guard let token = tokensStorage.get()?.accessToken else {
            completion(.failure(Error.token))
            return
        }

        guard let request = requestMaker.makeURLRequest(subreddit: subreddit, after: after) else {
            completion(.failure(Error.request))
            return
        }

        let session = sessionMaker.makeURLSession(with: token)

        dataLoader.loadData(with: session, request: request) { data, _, error in
            if let _ = error {
                return completion(.failure(Error.get))
            }

            guard let data = data else {
                return completion(.failure(Error.get))
            }

            guard let posts = self.decoder.decode(from: data) else {
                return completion(.failure(Error.decode))
            }

            return completion(.success(posts))
        }
    }
}

//MARK: - Error
private extension AuthorizedPostsLoader {
    typealias Error = AuthorizedPostsLoaderError
    
    enum AuthorizedPostsLoaderError: Swift.Error {
        case token
        case request
        case get
        case decode
    }
}
