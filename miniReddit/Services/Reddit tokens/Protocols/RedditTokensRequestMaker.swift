
import Foundation

protocol RedditTokensRequestMaker {
    func makeURLRequest(with parameter: String) -> URLRequest?
}
