
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var applicationCoordinator: Coordinator?
    private let dependencies = ApplicationDependencies()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        start()
    }
    
    private func start() {
        let rootViewController = UINavigationController()
        
        let coordinatorFactory = ApplicationCoordinatorFactory(
            modulesFactory: MainModulesFactory(
                dependencies: dependencies,
                action: { [weak self] in
                    DispatchQueue.main.async {
                        self?.start()
                    }
                })
        )
        let router = BaseRouter(rootController: rootViewController)
        
        applicationCoordinator = ApplicationCoordinator(
            coordinatorFactory: coordinatorFactory,
            router: router
        )
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        applicationCoordinator?.start()
    }
}
