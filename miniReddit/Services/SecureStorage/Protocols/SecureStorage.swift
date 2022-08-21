
import Foundation

protocol SecureStorage {
    func add(_ value: Data, forKey key: String) throws
    func get(byKey key: String) -> Data?
    func remove(byKey key: String) throws
}
