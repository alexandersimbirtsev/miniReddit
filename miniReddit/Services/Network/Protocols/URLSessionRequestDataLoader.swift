
import Foundation

protocol URLSessionRequestDataLoader {
    func loadData(
        with session: URLSession,
        request     : URLRequest,
        completion  : @escaping (Data?, URLResponse?, Error?) -> Void
    )
}

//MARK: - Unauthorized fallback
extension URLSessionRequestDataLoader {
    func unauthorizedFallback(_ fallback: URLSessionRequestDataLoader) -> URLSessionRequestDataLoader {
        NetworkDataLoaderWithUnauthorizedFallback(primary: self, fallback: fallback)
    }
}
