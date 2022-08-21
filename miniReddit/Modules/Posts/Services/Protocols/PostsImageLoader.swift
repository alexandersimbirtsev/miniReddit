
import UIKit

protocol PostsImageLoader {
    func getImage(with url: URL, completion: @escaping (UIImage) -> Void)
    func start(with url: URL)
    func stop(with url: URL)
}
