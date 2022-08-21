
import Foundation

protocol URLRequestDataLoader {
    func loadData(
        request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    )
}
