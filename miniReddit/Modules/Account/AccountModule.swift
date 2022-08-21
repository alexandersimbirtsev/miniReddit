
import UIKit

final class AccountModule {
    private let dependencies: Dependencies
    private let accountProviderFactory: AccountProviderFactory
    
    init(
        dependencies: Dependencies,
        redditAccountProviderFactory: AccountProviderFactory
    ) {
        self.dependencies = dependencies
        self.accountProviderFactory = redditAccountProviderFactory
    }
    
    private func userAuthorized() -> Bool {
        dependencies.tokensStorage.get() != nil
    }
    
    private func makeAccountProvider(isUserAuthorized: Bool) -> AccountProvider {
        return isUserAuthorized
            ? accountProviderFactory.makeAuthorizedAccountProvider()
            : accountProviderFactory.makeUnauthorizedAccountProvider()
    }
    
    private func makeButtonAction(
        isUserAuthorized: Bool,
        action: @escaping () -> Void
    ) -> () -> Void {
        
        weak var tokensStorage = dependencies.tokensStorage
        
        if isUserAuthorized {
            return {
                tokensStorage?.remove()
                action()
            }
        } else {
            weak var authenticationService = dependencies.redditAuthenticationService
            return {
                guard
                    let authenticationService = authenticationService,
                    let tokensStorage = tokensStorage
                else { return }
                
                let redditAccountService = RedditAccountService(
                    authenticationService: authenticationService,
                    tokensStorage: tokensStorage
                )
                redditAccountService.start(completion: action)
            }
        }
    }
}

//MARK: - AccountModuleFactory
extension AccountModule: AccountModuleFactory {
    func create(action: @escaping () -> Void) -> UIViewController {
        let isUserAuthorized = userAuthorized()
        
        let buttonAction = makeButtonAction(isUserAuthorized: isUserAuthorized, action: action)
        let buttonTitle  = isUserAuthorized ? "Logout" : "Login"
        let authButton   = MainAuthenticationButton(title: buttonTitle, action: buttonAction)
        
        let view = MainAccountView(authButton: authButton)
        
        let viewController = AccountViewController(
            provider: makeAccountProvider(isUserAuthorized: isUserAuthorized),
            makeView: {
                AccountScrollView(accountView: view)
            }
        )
        return viewController
    }
}
