
@testable import miniReddit
import UIKit

class MockedPostsCell: UITableViewCell, PostsCell {
    var id: String?
    var title: String?
    var ratio: CGFloat?
    var image: UIImage?
    var completion: (() -> Void)?
    
    func configure(title: String, ratio: CGFloat) {
        self.title = title
        self.ratio = ratio
    }
    
    func updateContent(with image: UIImage) {
        self.image = image
        completion?()
    }
}
