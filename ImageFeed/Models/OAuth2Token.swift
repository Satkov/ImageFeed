import Foundation

struct OAuth2Token: Decodable {
    var access_token: String
    var token_type: String
    var scope: String
    var created_at: Date
}

//{
//  "access_token": "YOUR_ACCESS_TOKEN",
//  "token_type": "bearer",
//  "scope": "public read_user",
//  "created_at": 1629388293
//}
