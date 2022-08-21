
import Foundation

protocol PostsDecoder {
    func decode(from data: Data) -> [RedditPost]?
}
