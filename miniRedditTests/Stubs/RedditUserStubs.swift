
@testable import miniReddit
import Foundation

class RedditUserStubs {
    static let one: RedditUser = .init(
        id     : "1",
        name   : "One",
        created: Date(),
        iconURL: URL(string: "https://apple.com")
    )
}
