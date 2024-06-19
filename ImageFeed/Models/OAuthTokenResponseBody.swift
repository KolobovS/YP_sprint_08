//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let created: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case created = "created_at"
    }
}
