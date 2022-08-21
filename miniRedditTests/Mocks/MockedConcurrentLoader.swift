
@testable import miniReddit
import UIKit

class MockedConcurrentLoader: ConcurrentLoader {
    var data: Data?
    
    var startCounter = 0
    var startURL: URL?
    
    var stopCounter = 0
    var stopURL: URL?
    
    func getData(with url: URL, completion: @escaping (Data) -> Void) {
        guard let data = data else { return }
        
        completion(data)
    }
    
    func start(with url: URL) {
        startCounter = 1
        startURL = url
    }
    
    func stop(with url: URL) {
        stopCounter = 1
        stopURL = url
    }
}
