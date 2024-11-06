import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Date
}
