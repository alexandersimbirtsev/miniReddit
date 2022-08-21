
import Foundation

protocol URLCallbackRetriever {
    func makeCallback(completion: @escaping (Result<URL, Error>) -> Void)
}
