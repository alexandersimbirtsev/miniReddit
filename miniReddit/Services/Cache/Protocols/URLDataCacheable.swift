
import Foundation

typealias URLDataCacheable = CacheURLDataSaver & CacheURLDataLoader

protocol CacheURLDataSaver {
    func save(_ data: Data?, for url: URL)
}

protocol CacheURLDataLoader {
    func get(from url: URL) -> Data?
}
