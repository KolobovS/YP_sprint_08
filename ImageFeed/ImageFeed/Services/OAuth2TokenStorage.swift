import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    static var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
            return token
        }
        set {
            if let value = newValue {
                let isSuccess = KeychainWrapper.standard.set(value, forKey: Keys.token.rawValue)
                guard isSuccess else { return }
            } else {
                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                guard removeSuccessful else { return }
            }
        }
    }
}
