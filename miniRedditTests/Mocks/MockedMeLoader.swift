
@testable import miniReddit
import Foundation

class MockedMeLoader: MeLoader {
    var user: RedditUser?
    var returnUser = true
    
    func load(completion: @escaping (Result<RedditUser, Error>) -> Void) {
        if returnUser {
            guard let user = user else { return }
            completion(.success(user))
        } else {
            completion(.failure(TestError()))
        }
    }
}
