
import UIKit

class PostsTableView: UITableView {
    typealias TableViewDelegate = UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching
    
    private let tableViewDelegate: TableViewDelegate?
    
    init(delegate: TableViewDelegate? = nil) {
        self.tableViewDelegate = delegate
        
        super.init(frame: .zero, style: .plain)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configure() {
        let automaticDimension = UITableView.automaticDimension
        
        rowHeight = automaticDimension
        estimatedRowHeight = automaticDimension
        
        separatorStyle = .none
        allowsSelection = false
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        tableFooterView = activityIndicator
        
        refreshControl = UIRefreshControl()
        
        delegate           = tableViewDelegate
        dataSource         = tableViewDelegate
        prefetchDataSource = tableViewDelegate
    }
}

//MARK: - PostsView
extension PostsTableView: PostsView {}
