
protocol PostsModelLoader {
    func getPosts(
        after: String?,
        completion: @escaping (Result<[PostsCellModel], Error>) -> Void
    )
}
