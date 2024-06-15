import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: URL
        let medium: URL
        let large: URL
        
        enum CodingKeys: String, CodingKey {
            case small
            case medium
            case large
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

enum ProfileImageError: Error {
    case invalidURL
    case noData
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}
