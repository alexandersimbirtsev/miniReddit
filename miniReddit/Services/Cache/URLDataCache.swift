
import Foundation

final class URLDataCache {
    private var cache: NSCache<NSURL, NSData> = {
        let cache = NSCache<NSURL, NSData>()
        cache.countLimit = 200
        return cache
    }()
}

//MARK: - URLDataCacher
extension URLDataCache: URLDataCacheable {
    func get(from url: URL) -> Data? {
        cache.object(forKey: url as NSURL) as? Data
    }
    
    func save(_ data: Data?, for url: URL) {
        guard let data = data else { return }
        
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
}
