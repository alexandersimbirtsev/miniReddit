
import Foundation

final class RedditUserDecoderFromJSON {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

extension RedditUserDecoderFromJSON: RedditUserDecoder {
    func decode(from data: Data) -> RedditUser? {
        try? decoder.decode(RedditUser.self, from: data)
    }
}
