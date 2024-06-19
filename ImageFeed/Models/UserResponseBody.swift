//
//  UserResponseBody.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 20.02.2024.
//

import Foundation

struct UserResponseBody: Decodable {
    let id: String
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
