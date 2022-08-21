
import UIKit

final class PostsTableViewCell: UITableViewCell {
    var id: String?
    
    private let content: UIImageView = {
        let content = UIImageView()
        content.backgroundColor = .systemGray
        content.contentMode     = .scaleAspectFit
        content.clipsToBounds   = true
        return content
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var contentHeightConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(content)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
            
        let contentSafeGuide = contentView.safeAreaLayoutGuide
        let titleLabelPadding: UIEdgeInsets = .init(top: 25, left: 10, bottom: -5, right: -10)
        
        contentHeightConstraint = content.heightAnchor.constraint(equalTo: content.widthAnchor)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo     : contentSafeGuide.topAnchor,      constant: titleLabelPadding.top),
            titleLabel.leadingAnchor.constraint(equalTo : contentSafeGuide.leadingAnchor,  constant: titleLabelPadding.left),
            titleLabel.trailingAnchor.constraint(equalTo: contentSafeGuide.trailingAnchor, constant: titleLabelPadding.right),
            titleLabel.bottomAnchor.constraint(equalTo  : content.topAnchor,               constant: titleLabelPadding.bottom),

            content.leadingAnchor.constraint(equalTo : contentSafeGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentSafeGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo  : contentSafeGuide.bottomAnchor),
            contentHeightConstraint,
        ])
    }
    
    private func changeContentHeightConstraint(with multiplier: CGFloat) {
        contentHeightConstraint.isActive = false
        contentHeightConstraint = content.heightAnchor.constraint(equalTo: content.widthAnchor, multiplier: multiplier)
        contentHeightConstraint.isActive = true
    }
}

//MARK: - PostsCell
extension PostsTableViewCell: PostsCell {
    func configure(title: String, ratio: CGFloat) {
        content.image = nil
        self.titleLabel.text = title

        changeContentHeightConstraint(with: ratio)
    }
    
    func updateContent(with image: UIImage) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.content.image = image
        }
    }
}
