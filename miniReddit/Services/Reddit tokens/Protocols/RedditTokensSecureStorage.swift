
protocol RedditTokensSecureStorage: AnyObject {
    func save(_ tokens: RedditTokens)
    func get() -> RedditTokens?
    func remove()
}
