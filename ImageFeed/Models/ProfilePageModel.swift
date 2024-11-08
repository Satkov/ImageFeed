import Foundation

struct ProfileInfo: Decodable {
    var firstName: String
    var lastName: String
    var username: String
    var bio: String?
    var fullName: String {
        "\(self.firstName) \(self.lastName)"
    }
}

struct ProfileImageURL: Decodable {
    var image: ImagesSizes
    
    enum CodingKeys: String, CodingKey {
        case image = "profileImage"
    }
}

struct ImagesSizes: Decodable {
    var small: String
    var medium: String
    var large: String
}
