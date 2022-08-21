
protocol RedditTokensRetriever {
    func getTokens(
        with parameter: String,
        completion: @escaping (Result<RedditTokens, Error>) -> Void
    )
}
