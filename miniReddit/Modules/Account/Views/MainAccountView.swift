
import UIKit

final class MainAccountView: UIView {
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let authButton: AuthenticationButton
    
    init(authButton: AuthenticationButton) {
        self.authButton = authButton
        
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(authButton)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        nameLabel.translatesAutoresizingMaskIntoConstraints  = false
        infoLabel.translatesAutoresizingMaskIntoConstraints  = false
        authButton.translatesAutoresizingMaskIntoConstraints = false
        
        let spaceBetweenViews    : CGFloat = 10
        let buttonBottomSpace    : CGFloat = -20
        let buttonWidthMultiplier: CGFloat = 0.5
        
        let customConstraints: [NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo     : topAnchor),
            imageView.leadingAnchor.constraint(equalTo : leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo  : safeAreaLayoutGuide.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo     : imageView.bottomAnchor, constant: spaceBetweenViews),
            nameLabel.centerXAnchor.constraint(equalTo : centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo     : nameLabel.bottomAnchor),
            infoLabel.centerXAnchor.constraint(equalTo : centerXAnchor),
            
            authButton.topAnchor.constraint(equalTo    : infoLabel.bottomAnchor, constant  : spaceBetweenViews),
            authButton.bottomAnchor.constraint(equalTo : bottomAnchor,           constant  : buttonBottomSpace),
            authButton.widthAnchor.constraint(equalTo  : widthAnchor,            multiplier: buttonWidthMultiplier),
            authButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        
        NSLayoutConstraint.activate(customConstraints)
    }
}

//MARK: - AccountView
extension MainAccountView: AccountView {
    func updateContent(with account: Account) {
        nameLabel.text = account.name
        infoLabel.text = account.info

        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve) {
            self.imageView.image = account.image
        }
    }
}
