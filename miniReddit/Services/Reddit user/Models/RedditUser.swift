
import Foundation

struct RedditUser {
    let id     : String
    let name   : String
    let created: Date
    let iconURL: URL?
}

//MARK: - CodingKeys
extension RedditUser {
    enum CodingKeys: String, CodingKey {
        case id            = "id"
        case name          = "name"
        case created       = "createdUtc"
        case iconURLString = "iconImg"
    }
}

//MARK: - Decodable
extension RedditUser: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id      = try container.decode(String.self, forKey: .id)
        name    = try container.decode(String.self, forKey: .name)
        created = try container.decode(Date.self,   forKey: .created)
        
        let iconStringURL = try container.decode(String.self, forKey: .iconURLString)
        iconURL = Self.makeIconURL(from: iconStringURL)
    }
}

//MARK: - Helpers
extension RedditUser {
    static private func makeIconURL(from iconURLString: String) -> URL? {
        guard
            let index = iconURLString.firstIndex(of: "?")
        else { return nil }
        
        let iconString = String(iconURLString.prefix(upTo: index))
        return URL(string: iconString)
    }
}
