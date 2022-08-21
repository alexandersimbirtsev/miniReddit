
@testable import miniReddit
import XCTest

class PostsConcurrentImageLoaderTests: XCTestCase {
    
    func testPostsConcurrentImageLoader_GetImage_NotNil() throws {
        // Given
        let loader = MockedConcurrentLoader()
        loader.data = UIImage(systemName: "circle")?.pngData()
        
        let sut = PostsConcurrentImageLoader(loader: loader)
        let url = URL(string: "https://www.apple.com")!
        var image: UIImage?
        
        // When
        sut.getImage(with: url) { loadedImage in
            image = loadedImage
        }
        
        // Then
        XCTAssertNotNil(image)
    }
    
    func testPostsConcurrentImageLoader_GetImage_IsNil() throws {
        // Given
        let loader = MockedConcurrentLoader()
        
        let sut = PostsConcurrentImageLoader(loader: loader)
        let url = URL(string: "https://www.apple.com")!
        var image: UIImage?
        
        // When
        sut.getImage(with: url) { loadedImage in
            image = loadedImage
        }
        
        // Then
        XCTAssertNil(image)
    }
    
    func testPostsConcurrentImageLoader_GetImage_NotImage() throws {
        // Given
        let loader = MockedConcurrentLoader()
        loader.data = "Lorem ipsum".data(using: .utf8)
        
        let sut = PostsConcurrentImageLoader(loader: loader)
        let url = URL(string: "https://www.apple.com")!
        var image: UIImage?
        
        // When
        sut.getImage(with: url) { loadedImage in
            image = loadedImage
        }
        
        // Then
        XCTAssertNil(image)
    }
    
    func testPostsConcurrentImageLoader_Start() throws {
        // Given
        let loader = MockedConcurrentLoader()
        
        let url = URL(string: "https://www.apple.com")!
        let count = 1
        
        let sut = PostsConcurrentImageLoader(loader: loader)
        
        // When
        sut.start(with: url)
        
        // Then
        XCTAssertEqual(url, loader.startURL)
        XCTAssertEqual(loader.startCounter, count)
    }
    
    func testPostsConcurrentImageLoader_Stop() throws {
        // Given
        let loader = MockedConcurrentLoader()
        
        let url = URL(string: "https://www.apple.com")!
        let count = 1
        
        let sut = PostsConcurrentImageLoader(loader: loader)
        
        // When
        sut.stop(with: url)
        
        // Then
        XCTAssertEqual(url, loader.stopURL)
        XCTAssertEqual(loader.stopCounter, count)
    }
}
