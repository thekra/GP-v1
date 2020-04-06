//
//  signinResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 08/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

// MARK: - SigninResponse
struct SigninResponse: Codable {
    let accessToken, tokenType, expiresAt: String
    let userData: User_Data
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresAt = "expires_at"
        case userData = "user_data"
    }
}

// MARK: - UserData
struct User_Data: Codable {
    let id: Int
    let name, phone: String?
    let email, active, roleID: String?
    let company: String?
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, active
        case roleID = "role_id"
        case company
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
