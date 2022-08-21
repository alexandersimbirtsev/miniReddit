
import Foundation

protocol URLDataLoader {
    func loadData(
        url: URL,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    )
}
