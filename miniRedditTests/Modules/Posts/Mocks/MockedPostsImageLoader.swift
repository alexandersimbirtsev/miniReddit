
@testable import miniReddit
import UIKit

class MockedPostsImageLoader: PostsImageLoader {
    var image: UIImage?
    
    var startCounter = 0
    var startURL: URL?
    
    var stopCounter = 0
    var stopURL: URL?
    
    func getImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        guard let image = image else { return }
        
        completion(image)
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
