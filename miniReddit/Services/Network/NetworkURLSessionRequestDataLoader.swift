
import Foundation

final class NetworkURLSessionRequestDataLoader {}

//MARK: - URLSessionRequestDataLoader
extension NetworkURLSessionRequestDataLoader: URLSessionRequestDataLoader {
    func loadData(with session: URLSession, request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session
            .dataTask(with: request, completionHandler: completion)
            .resume()
    }
}
