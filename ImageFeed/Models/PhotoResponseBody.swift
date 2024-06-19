//
//  PhotosResponseBody.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 29.02.2024.
//

import Foundation

struct LikeResponseBody: Decodable {
    let photo: PhotoResponseBody
}

struct PhotoResponseBody: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: PhotosUrls
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

struct PhotosUrls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
