
@testable import miniReddit
import Foundation

class PostsCellModelStubs {
    static let one: PostsCellModel = .init(
        id     : "1",
        title  : "One",
        content: .init(url: URL(string: "https://www.apple.com")!, ratio: 1)
    )
}
