
import Foundation

final class RedditTokensDecoderWithJSON {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

//MARK: - RedditTokensDecoder
extension RedditTokensDecoderWithJSON: RedditTokensDecoder {
    func decode(from data: Data) -> RedditTokens? {
        try? decoder.decode(RedditTokens.self, from: data)
    }
}
