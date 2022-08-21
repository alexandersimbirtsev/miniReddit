
import UIKit

final class MainModulesFactory {
    private let dependencies: Dependencies
    private let action: () -> Void
    
    init(
        dependencies: Dependencies,
        action: @escaping () -> Void
    ) {
        self.dependencies = dependencies
        self.action = action
    }
}

//MARK: - ModulesFactory
extension MainModulesFactory: ModulesFactory {
    func makePostsModule() -> UIViewController {
        let postsLoaderFactory = MainPostsLoaderFactory(
            dependencies: dependencies,
            postsDecoder: PostsDecoderFromJSON()
        )
        return PostsModule(
            dependencies: dependencies,
            postsLoaderFactory: postsLoaderFactory
        )
        .create()
    }
    
    func makeAccountModule() -> UIViewController {
        let redditAccountProviderFactory = RedditAccountProviderFactory(dependencies: dependencies)
        
        return AccountModule(
            dependencies: dependencies,
            redditAccountProviderFactory: redditAccountProviderFactory
        )
        .create(action: action)
    }
}
