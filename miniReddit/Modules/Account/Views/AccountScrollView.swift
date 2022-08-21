
import UIKit

final class AccountScrollView: UIScrollView {
    private let accountView: AccountView
    
    init(accountView: AccountView) {
        self.accountView = accountView
        
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        delaysContentTouches           = false
        
        backgroundColor = .systemBackground
        
        addSubview(accountView)
    }
    
    private func setupConstraints() {
        accountView.translatesAutoresizingMaskIntoConstraints = false
        
        let customConstraints: [NSLayoutConstraint] = [
            accountView.topAnchor.constraint(equalTo     : topAnchor),
            accountView.bottomAnchor.constraint(equalTo  : bottomAnchor),
            accountView.leadingAnchor.constraint(equalTo : leadingAnchor),
            accountView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            accountView.widthAnchor.constraint(equalTo: widthAnchor)
        ]
        
        NSLayoutConstraint.activate(customConstraints)
    }
}

//MARK: - AccountView
extension AccountScrollView: AccountView {
    func updateContent(with account: Account) {
        accountView.updateContent(with: account)
    }
}
