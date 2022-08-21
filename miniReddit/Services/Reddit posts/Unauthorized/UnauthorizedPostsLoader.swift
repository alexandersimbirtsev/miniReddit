
import Foundation

final class UnauthorizedPostsLoader {
    private let requestMaker     : RedditPostsRequestMaker
    private let networkDataLoader: URLRequestDataLoader
    private let decoder          : PostsDecoder
    
    init(
        requestMaker     : RedditPostsRequestMaker,
        networkDataLoader: URLRequestDataLoader,
        decoder          : PostsDecoder
    ) {
        self.requestMaker      = requestMaker
        self.networkDataLoader = networkDataLoader
        self.decoder           = decoder
    }
}

//MARK: - PostsLoader
extension UnauthorizedPostsLoader: PostsLoader {
    func loadPosts(subreddit: String, after: String?, completion: @escaping (Result<[RedditPost], Swift.Error>) -> Void) {
        
        guard let request = requestMaker.makeURLRequest(subreddit: subreddit, after: after) else {
            completion(.failure(UnauthorizedPostsLoaderError.request))
            return
        }
        
        networkDataLoader.loadData(request: request) { data, _, error in
            if let _ = error {
                return completion(.failure(Error.load))
            }
            
            guard let data = data else {
                return completion(.failure(Error.load))
            }
            
            guard let posts = self.decoder.decode(from: data) else {
                return completion(.failure(Error.decode))
            }
            
            return completion(.success(posts))
        }
    }
}

//MARK: - Error
private extension UnauthorizedPostsLoader {
    typealias Error = UnauthorizedPostsLoaderError
    enum UnauthorizedPostsLoaderError: Swift.Error {
        case request
        case load
        case decode
    }
}
