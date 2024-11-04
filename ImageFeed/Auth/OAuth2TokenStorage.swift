import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "userAccessToken"
    private let userDafaults = UserDefaults.standard

    var token: String? {
        get {
            userDafaults.string(forKey: tokenKey)
        }
        set {
            userDafaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
