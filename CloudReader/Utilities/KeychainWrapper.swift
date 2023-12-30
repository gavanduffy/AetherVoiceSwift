import Foundation
import Security

class KeychainWrapper {
    static func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            return dataTypeRef as? Data
        }
        return nil
    }

    static func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key ] as [String : Any]

        return SecItemDelete(query as CFDictionary) == noErr
    }
}
