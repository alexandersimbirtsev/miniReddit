
import UIKit

final class MainAuthenticationButton: UIButton {
    private let action: () -> Void
    
    private let titleFont: UIFont = .monospacedSystemFont(
        ofSize: UIFont.buttonFontSize,
        weight: .medium
    )
    private var shadowRadius: CGFloat { isHighlighted ? 5 : 10 }
    private var customAlpha : CGFloat { isHighlighted ? 0.5 : 1 }
    
    init(title: String, action: @escaping () -> Void) {
        self.action = action
        
        super.init(frame: .zero)
        
        setup(title: title)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override var isHighlighted: Bool {
        didSet {
            layer.shadowRadius = shadowRadius
            alpha = customAlpha
        }
    }
    
    private func setup(title: String) {
        let bgColor      : UIColor = .systemBlue
        let cornerRadius : CGFloat = 15
        let shadowColor  : CGColor = UIColor.systemBlue.cgColor
        let shadowOffset : CGSize  = .zero
        let shadowOpacity: Float   = 1
        
        setTitle(title, for: .normal)
        titleLabel?.font = titleFont
        
        layer.cornerRadius  = cornerRadius
        layer.shadowColor   = shadowColor
        layer.shadowRadius  = shadowRadius
        layer.shadowOffset  = shadowOffset
        layer.shadowOpacity = shadowOpacity
        
        backgroundColor = bgColor
        
        self.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    @objc private func onTap() {
        action()
    }
}

//MARK: - AuthenticationButton
extension MainAuthenticationButton: AuthenticationButton {
    func authenticate(completion: () -> Void) {
        action()
    }
}
