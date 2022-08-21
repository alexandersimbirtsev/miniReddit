
@testable import miniReddit
import XCTest

class MainPostsLoaderTests: XCTestCase {

    func testMainPostsLoaderTests_GetPosts_Successful() throws {
        // Given
        let redditPost = RedditPostStubs.one
        let postsLoader = MockedPostsLoader()
        postsLoader.returnPosts = true
        postsLoader.posts = [redditPost]
        
        var posts: [PostsCellModel] = []
        
        let sut = MainPostsLoader(postsLoader: postsLoader)
        
        // When
        sut.getPosts(after: nil) { result in
            if case .success(let loadedPosts) = result {
                posts = loadedPosts
            }
        }
        
        // Then
        XCTAssertEqual(posts.count, postsLoader.posts.count)
    }
    
    func testMainPostsLoaderTests_GetPosts_NewBatch() throws {
        // Given
        let redditPost = RedditPostStubs.one
        let postsLoader = MockedPostsLoader()
        postsLoader.returnPosts = true
        postsLoader.posts = [redditPost]
        
        var posts: [PostsCellModel] = []
        
        let sut = MainPostsLoader(postsLoader: postsLoader)
        
        // When
        sut.getPosts(after: "newBatch") { result in
            if case .success(let loadedPosts) = result {
                posts = loadedPosts
            }
        }
        
        // Then
        XCTAssertLessThan(postsLoader.posts.count, posts.count)
    }
    
    func testMainPostsLoaderTests_GetPosts_Failed() throws {
        // Given
        let postsLoader = MockedPostsLoader()
        postsLoader.returnPosts = false
        
        var failsCount = 0
        
        let sut = MainPostsLoader(postsLoader: postsLoader)
        
        // When
        sut.getPosts(after: "newBatch") { result in
            if case .failure = result {
                failsCount = 1
            }
        }
        
        // Then
        XCTAssertEqual(failsCount, 1)
    }
}
