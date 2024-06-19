import Foundation

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(profileResponseBody: ProfileResponseBody) {
        self.username = profileResponseBody.userName
        self.name = "\(profileResponseBody.firstName) \(profileResponseBody.lastName ?? "")"
        self.loginName = "@" + self.username
        self.bio = profileResponseBody.bio ?? ""
    }
}
