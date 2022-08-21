
import UIKit

final class MainAccountProvider {
    private let meLoader: MeLoader
    private let dataLoader: URLDataLoader
    
    init(
        meLoader: MeLoader,
        dataLoader: URLDataLoader
    ) {
        self.meLoader = meLoader
        self.dataLoader = dataLoader
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        dataLoader.loadData(url: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}

//MARK: - AccountProvider
extension MainAccountProvider: AccountProvider {
    func loadMe(completion: @escaping (Account) -> Void) {
        meLoader.load { [weak self] result in
            switch result {
            case .success(let user):
                guard let imageURL = user.iconURL else { return }
                
                self?.loadImage(from: imageURL, completion: { image in
                    let image = image != nil ? image : UIImage(named: "incognito")
                    let meModel = Account(user: user, image: image)
                    completion(meModel)
                })
            case .failure:
                completion(.default)
            }
        }
    }
}
