
import Foundation

final class NetworkURLDataLoader {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}

//MARK: - URLDataLoader
extension NetworkURLDataLoader: URLDataLoader {
    func loadData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session
            .dataTask(with: url, completionHandler: completion)
            .resume()
    }
}
