import Foundation

struct ProfilePageModel {
    var username: String
    var fullName: String
    var bio: String?
    var profileImageURL: URL
}

struct ProfileInfo: Decodable {
    var firstName: String
    var lastName: String
    var username: String
    var bio: String?
}

struct ProfileImage: Decodable {
    var image: ImagesSizes
    
    enum CodingKeys: String, CodingKey {
        case image = "profileImage"
    }
}

struct ImagesSizes: Decodable {
    var small: URL
    var medium: URL
    var large: URL
}
