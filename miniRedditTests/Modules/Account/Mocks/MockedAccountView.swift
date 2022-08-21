
@testable import miniReddit
import Foundation
import UIKit

class MockedAccountView: UIView, AccountView {
    
    var updateCount = 0
    var account: Account?
    
    func updateContent(with account: Account) {
        updateCount = 1
        self.account = account
    }
}
