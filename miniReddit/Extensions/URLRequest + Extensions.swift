
import Foundation

extension URLRequest {
    init?(
        url       : URL,
        method    : HTTPMethod,
        parameters: [String: String]? = nil,
        timeout   : TimeInterval
    ) {
        self.init(url: url)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }

        if let parameters = parameters {
            components.setQueryItems(with: parameters)
        }

        guard let queryStringUTF8 = components.url?.query?.utf8 else { return nil }

        self.url             = url
        self.httpMethod      = method.rawValue
        self.httpBody        = Data(queryStringUTF8)
        self.timeoutInterval = timeout
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}
