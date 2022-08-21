
@testable import miniReddit
import XCTest

class MainAccountProviderTests: XCTestCase {
    
    func testMainAccountProvider_LoadMe_Successfully() throws {
        // Given
        let meLoader = MockedMeLoader()
        meLoader.user = RedditUserStubs.one
        
        let imageData = UIImage(systemName: "circle")?.pngData()
        let dataLoader = MockedURLDataLoader(data: imageData)
        
        var account: Account?
        
        let sut: AccountProvider = MainAccountProvider(meLoader: meLoader, dataLoader: dataLoader)
        
        // When
        sut.loadMe { me in
            account = me
        }
        
        // Then
        XCTAssertNotNil(account)
        XCTAssertNotNil(account?.image)
    }
}
