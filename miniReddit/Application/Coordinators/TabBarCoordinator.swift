
import UIKit

final class TabBarCoordinator: BaseCoordinator {
    private let tabBarsFactory: TabBarsFactory
    private let router: Router
    
    init(tabBarsFactory: TabBarsFactory, router: Router) {
        self.tabBarsFactory = tabBarsFactory
        self.router = router
    }
    
    override func start() {
        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [
            tabBarsFactory.makeFirstTab(),
            tabBarsFactory.makeSecondTab(),
        ]

        tabBarController.tabBar.backgroundColor = .systemBackground
        
        router.setRootModule(tabBarController, hideBar: true)
    }
}
