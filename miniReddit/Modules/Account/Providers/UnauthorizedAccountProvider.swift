
final class UnauthorizedAccountProvider {}

//MARK: - AccountProvider
extension UnauthorizedAccountProvider: AccountProvider {
    func loadMe(completion: @escaping (Account) -> Void) {
        completion(.default)
    }
}
