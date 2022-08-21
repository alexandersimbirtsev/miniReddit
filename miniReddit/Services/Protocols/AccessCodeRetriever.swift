
import Foundation

protocol AccessCodeRetriever {
    func makeAccessCode(
        from callback: URL,
        completion: @escaping (Result<String, Error>) -> Void
    )
}
