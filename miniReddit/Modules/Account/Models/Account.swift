
import UIKit

struct Account {
    let name : String
    let info : String
    let image: UIImage?
}

extension Account {
    static let `default`: Self = .init(
        name: "r/Incognito",
        info: "Redditor since now",
        image: UIImage(named: "incognito")
    )
}

//MARK: - RedditUser init
extension Account {
    init(user: RedditUser, image: UIImage?) {
        self.name = "r/\(user.name.capitalized)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        let created = dateFormatter.string(from: user.created)
        
        self.info = "Redditor since \(created)"
        self.image = image
    }
}
