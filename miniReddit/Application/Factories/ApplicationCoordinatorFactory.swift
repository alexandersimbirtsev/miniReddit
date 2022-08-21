
final class ApplicationCoordinatorFactory {
    private let modulesFactory: ModulesFactory
    
    init(modulesFactory: ModulesFactory) {
        self.modulesFactory = modulesFactory
    }
}

//MARK: - CoordinatorFactory
extension ApplicationCoordinatorFactory: CoordinatorFactory {
    func makeTabBarCoordinator(router: Router) -> Coordinator {
        TabBarCoordinator(
            tabBarsFactory: MainTabBarsFactory(modulesFactory: modulesFactory),
            router: router
        )
    }
}
