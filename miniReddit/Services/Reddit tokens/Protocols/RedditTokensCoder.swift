
import Foundation

typealias RedditTokensCoder = RedditTokensDecoder & RedditTokensEncoder

protocol RedditTokensDecoder {
    func decode(from data: Data) -> RedditTokens?
}

protocol RedditTokensEncoder {
    func encode(_ tokens: RedditTokens) -> Data?
}
