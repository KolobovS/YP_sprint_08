import Foundation

class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "accessToken")
            }
        }
    }
}

