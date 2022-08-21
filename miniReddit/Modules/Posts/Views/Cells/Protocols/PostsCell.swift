
import UIKit

protocol PostsCell: UITableViewCell {
    var id: String? { get set }
    
    func configure(title: String, ratio: CGFloat)
    func updateContent(with image: UIImage)
}
