
import Foundation

protocol RedditUserDecoder {
    func decode(from data: Data) -> RedditUser?
}
