
import Foundation

final class KeychainSecureStorage {
    private let service: String
    
    init(service: String) {
        self.service = service
    }
}

//MARK: - SecureStorage
extension KeychainSecureStorage: SecureStorage {
    func add(_ value: Data, forKey key: String) throws {
        try? remove(byKey: key)

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData  : value,
            kSecClass      : kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(query, nil)

        guard status == errSecSuccess else {
            throw Error.add
        }
    }
    
    func get(byKey key: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData : true,
            kSecMatchLimit : kSecMatchLimitOne,
            kSecClass      : kSecClassGenericPassword
        ] as CFDictionary
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard
            status == errSecSuccess,
            let data = item as? Data
        else { return nil }
        
        return data
    }
    
    func remove(byKey key: String) throws {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass      : kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess else {
            throw Error.remove
        }
    }
}

//MARK: - Error
private extension KeychainSecureStorage {
    typealias Error = KeychainSecureStorageError
    
    enum KeychainSecureStorageError: Swift.Error {
        case add
        case remove
    }
}
