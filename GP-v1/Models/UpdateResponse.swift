//
//  UpdateResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 09/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
struct UpdateResponse: Codable {
    let message: String
    let userInfo: User
    let city, neighborhood: Cityy
    enum CodingKeys: String, CodingKey {
        case message
        case userInfo = "user_info"
        case city, neighborhood
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int
    let name, phone, email, active: String
    let roleID: String
    let company: JSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, active
        case roleID = "role_id"
        case company
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
