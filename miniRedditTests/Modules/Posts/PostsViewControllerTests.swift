
@testable import miniReddit
import XCTest

class PostsViewControllerTests: XCTestCase {
    
    func testPostsViewController_ViewDidLoad_LoadPostsSuccessfully() throws {
        // Given
        let newPost = PostsCellModelStubs.one
        let provider = MockedPostsProvider()
        provider.loadRowsCompletion = {
            provider.rows = [newPost]
        }
        
        let makeView = { MockedPostsView() }
        
        let sut = PostsViewController(provider: provider, makeView: makeView)
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(provider.rows.first, newPost)
    }
    
    func testPostsViewController_ViewDidLoad_DidNotLoadPosts() throws {
        // Given
        let provider = MockedPostsProvider()
        provider.loadRowsCompletion = nil
        
        let makeView = { MockedPostsView() }
        
        let sut = PostsViewController(provider: provider, makeView: makeView)
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(provider.rows.first, nil)
    }
}
