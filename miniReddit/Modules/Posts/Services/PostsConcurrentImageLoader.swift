
import UIKit

final class PostsConcurrentImageLoader {
    let loader: ConcurrentLoader
    
    init(loader: ConcurrentLoader) {
        self.loader = loader
    }
}

//MARK: - PostsImageLoader
extension PostsConcurrentImageLoader: PostsImageLoader {
    func getImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        loader.getData(with: url) { data in
            guard let image = UIImage(data: data) else { return }
            
            completion(image)
        }
    }
    
    func start(with url: URL) {
        loader.start(with: url)
    }
    
    func stop(with url: URL) {
        loader.stop(with: url)
    }
}
