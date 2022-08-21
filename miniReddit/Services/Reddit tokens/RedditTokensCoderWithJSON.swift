
import Foundation

final class RedditTokensCoderWithJSON {
    private let encoder = JSONEncoder()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

//MARK: - RedditTokensCoder
extension RedditTokensCoderWithJSON: RedditTokensCoder {
    func decode(from data: Data) -> RedditTokens? {
        try? decoder.decode(RedditTokens.self, from: data)
    }
    
    func encode(_ tokens: RedditTokens) -> Data? {
        try? encoder.encode(tokens)
    }
}
