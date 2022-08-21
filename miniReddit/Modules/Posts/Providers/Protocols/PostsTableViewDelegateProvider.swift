
import UIKit

protocol PostsTableViewDelegateProvider {
    var rowsCount: Int { get }
    
    func postIdentifier(at: Int) -> String?
    func post(at: Int) -> PostsCellModel
    
    //MARK: - UITableViewDataSource
    func configuredCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    //MARK: - UITableViewDelegate
    func onCellWillDisplay(_ cell: UITableViewCell, indexPath: IndexPath)
    func onCellDidEndDisplaying(for row: Int)
    
    //MARK: - UITableViewDataSourcePrefetching
    func onCellPrefetching(tableView: UITableView, indexPaths: [IndexPath])
    func onCellCancelPrefetching(at indexPaths: [IndexPath])
}
