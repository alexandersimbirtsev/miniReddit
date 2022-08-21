
import UIKit

final class PostsTableViewDelegate: NSObject {
    private let provider: PostsTableViewDelegateProvider
    
    init(provider: PostsTableViewDelegateProvider) {
        self.provider = provider
    }
}

//MARK: - UITableViewDataSource
extension PostsTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provider.rowsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        provider.configuredCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension PostsTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        provider.onCellWillDisplay(cell, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        provider.onCellDidEndDisplaying(for: indexPath.row)
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension PostsTableViewDelegate: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        provider.onCellPrefetching(tableView: tableView, indexPaths: indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        provider.onCellCancelPrefetching(at: indexPaths)
    }
}
