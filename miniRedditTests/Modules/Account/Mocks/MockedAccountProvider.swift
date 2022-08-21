
@testable import miniReddit

class MockedAccountProvider: AccountProvider {
    var account: Account?
    
    func loadMe(completion: @escaping (Account) -> Void) {
        guard let account = account else {
            return
        }
        
        completion(account)
    }
}
