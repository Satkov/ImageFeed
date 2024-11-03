import Foundation

struct OAuthTokenResponseBody: Decodable {
    var access_token: String
    var token_type: String
    var scope: String
    var created_at: Date
}

