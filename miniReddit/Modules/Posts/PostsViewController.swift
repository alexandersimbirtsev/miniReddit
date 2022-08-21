
import UIKit

final class PostsViewController: UIViewController {
    private let provider: PostsProvider
    private let makeView: () -> PostsView
    
    private func view() -> PostsView {
        view as! PostsView
    }
    
    init(
        provider: PostsProvider,
        makeView: @escaping () -> PostsView
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
        
        setup()
        getRows()
    }
    
    private func setup() {
        view().refreshControl?.addTarget(self, action: #selector(getRows), for: .valueChanged)
    }

    @objc private func getRows() {
        view().refreshControl?.beginRefreshing()
        
        provider.loadRows(after: nil) { [weak self] in
            DispatchQueue.main.async {
                self?.view().refreshControl?.endRefreshing()
                self?.view().reloadData()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        view().reloadData()
    }
}
