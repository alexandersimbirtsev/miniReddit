
import UIKit

final class PostsModule {
    private let dependencies: Dependencies
    private let postsLoaderFactory: PostsLoaderFactory
    
    init(
        dependencies: Dependencies,
        postsLoaderFactory: PostsLoaderFactory
    ) {
        self.dependencies = dependencies
        self.postsLoaderFactory = postsLoaderFactory
    }
    
    private func makePostsLoader() -> PostsLoader {
        return dependencies.tokensStorage.get() == nil
            ? postsLoaderFactory.makeUnauthorizedPostsLoader()
            : postsLoaderFactory.makeAuthorizedPostsLoader()
    }
}

//MARK: - PostsModuleFactory
extension PostsModule: PostsModuleFactory {
    func create() -> UIViewController {
        let postsModelLoader = MainPostsLoader(postsLoader: makePostsLoader())
        let postsProvider = MainPostsProvider(postsLoader: postsModelLoader)
        
        let concurrentDataLoader = ConcurrentDataLoader(
            cache: URLDataCache(),
            makeOperation: { url in
                DataLoadOperation(
                    url: url,
                    dataLoader: NetworkURLDataLoader(session: .shared)
                )
            }
        )
        let tableViewDelegateProvider = MainPostsTableViewDelegateProvider<PostsTableViewCell>(
            provider: postsProvider,
            imageLoader: PostsConcurrentImageLoader(loader: concurrentDataLoader)
        )
        let tableViewDelegate = PostsTableViewDelegate(provider: tableViewDelegateProvider)
        
        let viewController = PostsViewController(
            provider: postsProvider,
            makeView: {
                let tableView = PostsTableView(delegate: tableViewDelegate)
                tableView.register(PostsTableViewCell.self)
                return tableView
            }
        )
        return viewController
    }
}
