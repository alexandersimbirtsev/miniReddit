
import Foundation

protocol ConcurrentLoader {
    func getData(with url: URL, completion: @escaping (Data) -> Void)
    func start(with url: URL)
    func stop(with url: URL)
}
