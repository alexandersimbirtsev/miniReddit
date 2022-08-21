
protocol AccountProvider {
    func loadMe(completion: @escaping (Account) -> Void)
}
