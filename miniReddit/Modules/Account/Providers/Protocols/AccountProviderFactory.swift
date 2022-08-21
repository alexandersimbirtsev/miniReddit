
protocol AccountProviderFactory {
    func makeAuthorizedAccountProvider() -> AccountProvider
    func makeUnauthorizedAccountProvider() -> AccountProvider
}
