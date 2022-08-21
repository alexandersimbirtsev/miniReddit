
class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func start() {}
}
