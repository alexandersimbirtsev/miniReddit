
import UIKit

final class AccountViewController: UIViewController {
    private let provider: AccountProvider
    private let makeView: () -> AccountView
    
    private func view() -> AccountView {
        view as! AccountView
    }
    
    init(
        provider: AccountProvider,
        makeView: @escaping () -> AccountView
    ) {
        self.provider = provider
        self.makeView = makeView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = makeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view().updateContent(with: .default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        provider.loadMe { [weak self] me in
            DispatchQueue.main.async {
                self?.view().updateContent(with: me)
            }
        }
    }
}
