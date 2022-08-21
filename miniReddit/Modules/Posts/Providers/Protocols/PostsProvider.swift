
protocol PostsProvider {
    var rows: [PostsCellModel] { get }
    
    func loadRows(after: String?, completion: (() -> Void)?)
}
