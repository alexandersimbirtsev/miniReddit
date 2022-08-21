
@testable import miniReddit
import XCTest

class MainPostsProviderTests: XCTestCase {

    func testMainPostsProvider_LoadRows_RewritePosts() throws {
        // Given
        let newPost = PostsCellModelStubs.one
        let postsLoader = MockedPostsModelLoader()
        postsLoader.result = .success([newPost])
        
        let promise = expectation(description: "Setting posts with DispatchQueue.main.async")
        
        let sut: PostsProvider = MainPostsProvider(postsLoader: postsLoader)
        
        // When
        sut.loadRows(after: nil) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 0.1)
        
        //Then
        XCTAssertEqual(sut.rows.first, newPost)
        XCTAssertEqual(sut.rows.count, 1)
    }
    
    func testMainPostsProvider_LoadRows_AddNewPosts() throws {
        // Given
        let newPost = PostsCellModelStubs.one
        let postsLoader = MockedPostsModelLoader()
        postsLoader.result = .success([newPost])
        
        let promise = expectation(description: "Setting posts with DispatchQueue.main.async")
        
        let sut = MainPostsProvider(postsLoader: postsLoader)
        sut.rows.append(newPost)
        
        // When
        sut.loadRows(after: "") {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 0.1)
        
        //Then
        XCTAssertEqual(sut.rows.count, 2)
    }
}
