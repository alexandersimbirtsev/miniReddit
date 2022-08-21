
import UIKit

final class MainTabBarsFactory {
    private let modulesFactory: ModulesFactory
    
    init(modulesFactory: ModulesFactory) {
        self.modulesFactory = modulesFactory
    }
}

//MARK: - TabBarsFactory
extension MainTabBarsFactory: TabBarsFactory {
    func makeFirstTab() -> UIViewController {
        let postsViewController = modulesFactory.makePostsModule()
        
        postsViewController.tabBarItem = .init(
            title: "Posts",
            image: UIImage(systemName: "doc.richtext"),
            tag: 0
        )
        return postsViewController
    }
    
    func makeSecondTab() -> UIViewController {
        let downloadedPostsViewController = modulesFactory.makeAccountModule()

        downloadedPostsViewController.tabBarItem = .init(
            title: "Account",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        return downloadedPostsViewController
    }
}
