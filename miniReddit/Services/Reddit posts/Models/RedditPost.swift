
import Foundation

struct RedditPost {
    let content : PostContent
    let id      : String
    let title   : String
}

//MARK: - CodingKeys
extension RedditPost {
    enum CodingKeys: String, CodingKey {
        case content
        case id
        case postHint
        case preview
        case title
        case url
    }
}

//MARK: - Decodable
extension RedditPost: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let url      = try container.decode(String.self,           forKey: .url)
        let postHint = try container.decodeIfPresent(String.self,  forKey: .postHint)
        let preview  = try container.decodeIfPresent(Preview.self, forKey: .preview)
        
        content = RedditPost.getContent(postHint: postHint ?? "", preview: preview, url: url)
        id      = try container.decode(String.self, forKey: .id)
        title   = try container.decode(String.self, forKey: .title)
    }
}

//MARK: - Hashable
extension RedditPost: Hashable {
    static func == (lhs: RedditPost, rhs: RedditPost) -> Bool {
        return lhs.id == rhs.id
    }
}

//MARK: - PostContent
extension RedditPost {
    enum PostContent: Decodable, Hashable {
        case image(url: URL, ratio: Double)
        case none
    }
}

//MARK: - Content types
private extension RedditPost {
    private enum PostHint: String, Decodable {
        case image
    }
    
    private enum PostImageType: String, Decodable {
        case jpg
        case png
    }
    
    private struct Preview: Decodable, Hashable {
        let images: [ImageContainer]?
        
        struct ImageContainer: Decodable, Hashable {
            let source: Source?
        }
        
        struct Source: Decodable, Hashable {
            let height: Double
            let width : Double
            let url   : String
        }
    }
}

//MARK: - Content defining
private extension RedditPost {
    private static func getContent(postHint: String, preview: Preview?, url: String) -> PostContent {
        if let image = imageContent(url: url, postHint: postHint, preview: preview) {
            return image
        } else {
            return .none
        }
    }
    
    private static func imageContent(url: String, postHint: String, preview: Preview?) -> PostContent? {
        if let realURL = URL(string: url),
           (postHint == PostHint.image.rawValue
            || realURL.pathExtension == PostImageType.jpg.rawValue
            || realURL.pathExtension == PostImageType.png.rawValue),
           let size = preview?.images?.first?.source {
            
            return .image(url: realURL, ratio: size.height / size.width)
            
        } else { return nil }
    }
}
