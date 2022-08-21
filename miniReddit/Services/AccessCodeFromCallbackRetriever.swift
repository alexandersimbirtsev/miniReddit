
import Foundation

final class AccessCodeFromCallbackRetriever {
    private let callbackParser: (URL) -> String?
    
    init(callbackParser: @escaping (URL) -> String?) {
        self.callbackParser = callbackParser
    }
}

//MARK: - AccessCodeRetriever
extension AccessCodeFromCallbackRetriever: AccessCodeRetriever {
    func makeAccessCode(from callback: URL, completion: @escaping (Result<String, Swift.Error>) -> Void) {

        if let accessCode = callbackParser(callback) {
            completion(.success(accessCode))
        } else {
            completion(.failure(Error.parse))
        }
    }
}

//MARK: - Error
private extension AccessCodeFromCallbackRetriever {
    typealias Error = AccessCodeFromCallbackRetrieverError
    
    enum AccessCodeFromCallbackRetrieverError: Swift.Error {
        case parse
    }
}
