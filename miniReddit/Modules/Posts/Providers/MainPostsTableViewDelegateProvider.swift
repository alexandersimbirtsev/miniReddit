
import UIKit

final class MainPostsTableViewDelegateProvider<Cell: PostsCell> {
    private let provider: PostsProvider
    private let imageLoader: PostsImageLoader
    
    private var isLoading = false
    
    init(
        provider: PostsProvider,
        imageLoader: PostsImageLoader
    ) {
        self.provider = provider
        self.imageLoader = imageLoader
    }
    
    private func loadRowsIfNeeded(
        _ row: Int,
        indicator: UIActivityIndicatorView?,
        completion: @escaping () -> Void
    ) {
        if isLoading { return }

        if row + 1 == provider.rows.count {
            isLoading = true
            let lastId = provider.rows[safe: row]?.id
            
            indicator?.startAnimating()
            
            provider.loadRows(after: lastId, completion: completion)
        }
    }
}

//MARK: - PostsTableViewDelegateProvider
extension MainPostsTableViewDelegateProvider: PostsTableViewDelegateProvider {
    var rowsCount: Int { provider.rows.count }
    
    func postIdentifier(at: Int) -> String? {
        provider.rows[safe: at]?.id
    }
    
    func post(at: Int) -> PostsCellModel {
        provider.rows[at]
    }
    
    //MARK: - UITableViewDataSource
    func configuredCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let post = provider.rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(Cell.self)
        
        cell.configure(title: post.title, ratio: post.content.ratio)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func onCellWillDisplay(_ cell: UITableViewCell, indexPath: IndexPath) {
        let cell = cell as! Cell
        
        let post = provider.rows[indexPath.row]
        cell.id = post.id
        
        imageLoader.getImage(with: post.content.url) { image in
            
            DispatchQueue.main.async {
                guard cell.id == post.id else { return }
                cell.updateContent(with: image)
            }
        }
    }
    
    func onCellDidEndDisplaying(for row: Int) {
        let url = provider.rows[row].content.url
        
        imageLoader.stop(with: url)
    }
    
    //MARK: - UITableViewDataSourcePrefetching
    func onCellPrefetching(tableView: UITableView, indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let url = provider.rows[indexPath.row].content.url
            
            imageLoader.start(with: url)
        }
        
        guard let maxRow = indexPaths.max()?.row else { return }

        let indicator = tableView.tableFooterView as? UIActivityIndicatorView

        loadRowsIfNeeded(maxRow, indicator: indicator) { [weak self, weak tableView] in
            DispatchQueue.main.async {
                indicator?.stopAnimating()
                tableView?.reloadData()
                self?.isLoading = false
            }
        }
    }
    
    func onCellCancelPrefetching(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let url = provider.rows[indexPath.row].content.url
            
            imageLoader.stop(with: url)
        }
    }
}
