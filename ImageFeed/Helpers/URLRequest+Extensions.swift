import UIKit

extension URLRequest {
    mutating func addUserBearerToken() {
        let tokenStorage = OAuth2TokenStorage()
        guard let token = tokenStorage.token else {
            assertionFailure("LOG: Network Error: invalid urlComponents")
            return
        }
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
