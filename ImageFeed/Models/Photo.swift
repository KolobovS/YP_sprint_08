//
//  Photo.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 29.02.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResponceBody: PhotoResponseBody) {
        self.id = photoResponceBody.id
        self.size = CGSize(width: Double(photoResponceBody.width), height: Double(photoResponceBody.height))
        self.createdAt = DateFormatManager.shared.iso8601Date(photoResponceBody.createdAt)
        self.welcomeDescription = photoResponceBody.description ?? ""
        self.thumbImageURL = photoResponceBody.urls.thumb
        self.largeImageURL = photoResponceBody.urls.full
        self.isLiked = photoResponceBody.likedByUser
    }
}

