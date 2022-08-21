
@testable import miniReddit
import Foundation

class MockedPostsModelLoader: PostsModelLoader {
    var after: String?
    var result: (Result<[PostsCellModel], Error>)?
    
    func getPosts(
        after: String?,
        completion: @escaping (Result<[PostsCellModel], Error>) -> Void
    ) {
        guard let result = result else { return }
        
        switch result {
        case .success(let post):
            completion(.success(post))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
