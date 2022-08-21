
import Foundation

struct ListingResponse<T: Decodable>: Decodable {
    let kind: String?
    let data: ListingData<T>?
}

struct ListingData<T: Decodable>: Decodable {
    let modhash : String?
    let dist    : Int?
    let children: [ListingContainer<T>]
    let after   : String?
    let before  : String?
}

struct ListingContainer<T: Decodable>: Decodable {
    let kind: String
    let data: T
}
