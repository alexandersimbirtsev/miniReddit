
import Foundation

struct RedditAPIConfiguration {
    let scheme  : String
    let host    : String
    let hostAuth: String
}

extension RedditAPIConfiguration {
    static let `default`: Self = .init(
        scheme  : "https",
        host    : "www.reddit.com",
        hostAuth: "oauth.reddit.com"
    )
}
