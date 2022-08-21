
protocol MeLoader {
    func load(completion: @escaping (Result<RedditUser, Error>) -> Void)
}
