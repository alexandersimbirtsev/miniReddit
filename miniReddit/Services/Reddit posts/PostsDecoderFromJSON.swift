
import Foundation

final class PostsDecoderFromJSON {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

//MARK: - PostsDecoder
extension PostsDecoderFromJSON: PostsDecoder {
    func decode(from data: Data) -> [RedditPost]? {
        guard
            let listing = try? decoder.decode(ListingResponse<RedditPost>.self, from: data),
            let posts = listing.data?.children.map(\.data)
        else {
            return []
        }
        
        return posts
    }
}
