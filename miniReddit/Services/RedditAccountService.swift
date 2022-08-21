
import Foundation

final class RedditAccountService {
    private let authenticationService: RedditAuthentication
    private let tokensStorage: RedditTokensSecureStorage
    
    private let operationQueue = OperationQueue()
    
    init(
        authenticationService: RedditAuthentication,
        tokensStorage: RedditTokensSecureStorage
    ) {
        self.authenticationService = authenticationService
        self.tokensStorage = tokensStorage
    }
    
    func start(completion: @escaping () -> Void) {
        guard let url = authenticationService.makeAuthenticationURL() else { return }
        
        let callbackURLScheme = AuthenticationConfiguration.default.callbackURLScheme

        let callbackRetriever = AuthenticationCallbackRetriever(
            url: url,
            scheme: callbackURLScheme
        )
        
        callbackRetriever.makeCallback { result in
            guard case .success(let callback) = result else { return }
            
            let operations = self.makeOperations(with: callback, completion: completion)
            
            self.operationQueue.addOperations(operations, waitUntilFinished: false)
        }
    }
    
    private func makeOperations(with callback: URL, completion: @escaping () -> Void) -> [Operation] {
        let accessCodeOperation    = makeAccessCodeOperation(callback: callback)
        let tokensLoadingOperation = makeTokensLoadingOperation()
        let tokensStoreOperation   = makeTokensStoreOperation(with: completion)
        
        tokensLoadingOperation.addDependency(accessCodeOperation)
        tokensStoreOperation.addDependency(tokensLoadingOperation)
        
        let operations = [
            accessCodeOperation,
            tokensLoadingOperation,
            tokensStoreOperation
        ]
        
        return operations
    }
}

//MARK: - Operations
private extension RedditAccountService {
    
    //MARK: - AccessCodeOperation
    private func makeAccessCodeOperation(callback: URL) -> Operation {
        let accessCodeRetriever = AccessCodeFromCallbackRetriever { [weak authenticationService] url in
            authenticationService?.makeAccessCodeFromCallback(url)
        }
        
        let accessCodeOperation = AccessCodeFromCallbackRetrieverOperation(
            callback: callback,
            accessCodeRetriever: accessCodeRetriever
        )
        return accessCodeOperation
    }
    
    //MARK: - TokensLoadingOperation
    private func makeTokensLoadingOperation() -> Operation {
        typealias OperationOne = AccessCodeFromCallbackRetrieverOperation
        
        let session = authenticationService.makeURLSession()
        let requestMaker = AuthorizedRedditTokensRequestMaker(authenticationService: authenticationService)
        
        let tokensRetriever = NetworkRedditTokensRetriever(
            dataLoader  : NetworkURLRequestDataLoader(session: session),
            requestMaker: requestMaker,
            decoder     : RedditTokensDecoderWithJSON()
        )
        let tokensLoaderOperation = NetworkRedditTokensRetrieverOperation<OperationOne>(
            tokensRetriever: tokensRetriever
        )
        return tokensLoaderOperation
    }
    
    //MARK: - TokensStoreOperation
    private func makeTokensStoreOperation(with completion: @escaping () -> Void) -> Operation {
        typealias OperationOne = AccessCodeFromCallbackRetrieverOperation
        typealias OperationTwo = NetworkRedditTokensRetrieverOperation<OperationOne>
        
        let storeOperation = KeychainRedditTokensSecureStorageOperation<OperationTwo>(secureStorage: tokensStorage)
        storeOperation.completionBlock = completion
        
        return storeOperation
    }
}
