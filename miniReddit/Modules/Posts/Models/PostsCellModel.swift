
import Foundation

struct PostsCellModel {
    let id     : String
    let title  : String
    let content: Content
}

extension PostsCellModel {
    struct Content {
        let url: URL
        let ratio: Double
    }
}

//MARK: - RedditPost init?
extension PostsCellModel {
    init?(post: RedditPost) {
        self.id = post.id
        self.title = post.title
        
        switch post.content {
        case .image(url: let url, ratio: let ratio):
            self.content = .init(url: url, ratio: ratio)
        default:
            return nil
        }
    }
}

//MARK: - Equatable
extension PostsCellModel: Equatable {
    static func == (lhs: PostsCellModel, rhs: PostsCellModel) -> Bool {
        lhs.id == rhs.id
    }
}
