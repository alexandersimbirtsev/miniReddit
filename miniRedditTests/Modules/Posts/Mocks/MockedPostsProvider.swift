
@testable import miniReddit
import Foundation

class MockedPostsProvider: PostsProvider {
    var loadRowsCompletion: (() -> Void)?
    
    var rows: [PostsCellModel] = []
    
    func loadRows(after: String?, completion: (() -> Void)?) {
        loadRowsCompletion?()
    }
}
