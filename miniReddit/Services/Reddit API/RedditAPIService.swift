
import Foundation

final class RedditAPIService {
    private let configuration: RedditAPIConfiguration
    
    init(configuration: RedditAPIConfiguration) {
        self.configuration = configuration
    }
}

extension RedditAPIService: RedditAPI {
    //MARK: - Me
    func makeMeURLRequest() -> URLRequest? {
        guard let meURL = makeMeURL() else { return nil}
        
        var meRequest = URLRequest(url: meURL)
        meRequest.timeoutInterval = 5
        
        return meRequest
    }
    
    //MARK: - Posts
    func makeAuthorizedPostsURLRequest(subreddit: String, afterID: String?) -> URLRequest? {
        var parameters = [
            "limit": "50",
            "raw_json": "1"
        ]
        
        if let postId = afterID {
            parameters["after"] = "t3_\(postId)"
        }
        
        guard let url = makeAuthorizedPostsURL(subreddit: subreddit, parameters: parameters) else { return nil}
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        return request
    }
    
    func makePostsURLRequest(subreddit: String, afterID: String?) -> URLRequest? {
        var parameters = [
            "limit": "50",
            "raw_json": "1"
        ]
        
        if let postId = afterID {
            parameters["after"] = "t3_\(postId)"
        }
        
        guard let url = makePostsURL(subreddit: subreddit, parameters: parameters) else { return nil}
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        return request
    }
    
    //MARK: - Session
    func makeSession(withHeader header: String) -> URLSession {
        .init(
            configuration: makeRedditSessionConfiguration(
                withHeader: makeBearer(with: header)
            )
        )
    }
    
    func makeUnauthorizedSession() -> URLSession {
        .init(
            configuration: makeRedditSessionConfiguration(withHeader: nil)
        )
    }
}

//MARK: - Helpers
private extension RedditAPIService {
    private func makeRedditSessionConfiguration(withHeader header: String?) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        var headers: [String: String] = [:]
        
        if let header = header {
            headers["Authorization"] = header
        }

        configuration.httpAdditionalHeaders = headers
        configuration.waitsForConnectivity = true

        return configuration
    }
    
    private func makeBearer(with accessToken: String) -> String {
        "bearer \(accessToken)"
    }
    
    //MARK: - Me
    private func makeMeURL() -> URL? {
        var meURL = URL(
            scheme: configuration.scheme,
            host  : configuration.hostAuth,
            path  : Method.me.path
        )
        meURL?.appendPathExtension("json")
        return meURL
    }
    
    //MARK: - Posts
    private func makeAuthorizedPostsURL(subreddit: String, parameters: [String: String]) -> URL? {
        var url: URL? = URL(
            scheme    : configuration.scheme,
            host      : configuration.hostAuth,
            path      : Method.subreddit(name: subreddit).path,
            parameters: parameters)
        
        url?.appendPathExtension("json")
        
        return url
    }
    
    private func makePostsURL(subreddit: String, parameters: [String: String]) -> URL? {
        var url: URL? = URL(
            scheme    : configuration.scheme,
            host      : configuration.host,
            path      : Method.subreddit(name: subreddit).path,
            parameters: parameters)
        
        url?.appendPathExtension("json")
        
        return url
    }
}

//MARK: - Method
private extension RedditAPIService {
    private enum Method {
        case me
        case subreddit(name: String)
        
        var path: String {
            switch self {
            case .me:
                return "/api/v1/me"
            case .subreddit(name: let name):
                return "/r/\(name)"
            }
        }
    }
}
