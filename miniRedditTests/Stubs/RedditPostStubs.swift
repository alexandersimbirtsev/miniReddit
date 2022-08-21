
@testable import miniReddit
import Foundation

class RedditPostStubs {
    static let one: RedditPost = .init(
        content: .image(url: URL(string: "https://www.apple.com")!, ratio: 2),
        id: "1",
        title: "One"
    )
}
