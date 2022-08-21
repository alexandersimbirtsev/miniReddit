
@testable import miniReddit
import XCTest

class AccountViewControllerTests: XCTestCase {
    
    func testAccountViewControllerTests_ViewDidLoad_UpdateView() throws {
        // Given
        let accountView = MockedAccountView()
        let makeView = { accountView }
        let provider = MockedAccountProvider()
        let updateViewCount = 1
        
        let sut = AccountViewController(provider: provider, makeView: makeView)
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(updateViewCount, accountView.updateCount)
    }
    
    func testAccountViewControllerTests_ViewWillAppear_LoadMeAndUpdateView() throws {
        // Given
        let account = AccountStubs.one
        let accountView = MockedAccountView()
        let makeView = { accountView }
        let provider = MockedAccountProvider()
        provider.account = account
        
        let updateViewCount = 1
        
        let sut = AccountViewController(provider: provider, makeView: makeView)
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(updateViewCount, accountView.updateCount)
        XCTAssertNotNil(accountView.account)
    }
}
