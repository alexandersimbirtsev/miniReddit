
import Foundation

final class NetworkDataLoaderWithUnauthorizedFallback {
    private let primary: URLSessionRequestDataLoader
    private let fallback: URLSessionRequestDataLoader
    
    init(
        primary: URLSessionRequestDataLoader,
        fallback: URLSessionRequestDataLoader
    ) {
        self.primary = primary
        self.fallback = fallback
    }
}

//MARK: - URLSessionRequestDataLoader
extension NetworkDataLoaderWithUnauthorizedFallback: URLSessionRequestDataLoader {
    func loadData(
        with session: URLSession,
        request     : URLRequest,
        completion  : @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        primary.loadData(with: session, request: request) { [weak self] data, response, error in
            if
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 401
            {
                self?.fallback.loadData(with: session, request: request, completion: completion)
            }
            completion(data, response, error)
        }
    }
}
