
import Foundation

final class NetworkURLRequestDataLoader {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}

//MARK: - URLRequestDataLoader
extension NetworkURLRequestDataLoader: URLRequestDataLoader {
    func loadData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session
            .dataTask(with: request, completionHandler: completion)
            .resume()
    }
}
