
import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(coordinatorFactory: CoordinatorFactory, router: Router) {
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
