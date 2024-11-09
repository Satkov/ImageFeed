import UIKit
import SwiftKeychainWrapper

extension URLRequest {
    mutating func addUserBearerToken() {
        let token = KeychainWrapper.standard.string(forKey: KeychainWrapper.keychainKeys.userToken)
        guard let token = token else {
            logError(message: "Network Error: invalid urlComponents")
            return
        }
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
