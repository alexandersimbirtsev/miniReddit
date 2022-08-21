
@testable import miniReddit
import Foundation

class MockedURLDataLoader: URLDataLoader {
    var data: Data?
    
    init(data: Data? = nil) {
        self.data = data
    }
    
    func loadData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, nil, nil)
    }
}
