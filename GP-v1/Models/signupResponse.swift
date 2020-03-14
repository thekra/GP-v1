//
//  signupResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 11/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
// MARK: - SignupResponse
//
//struct signupResponse: Codable {
//    let access_token : String
//    let user_data: user_data
//
//    enum CodingKeys: CodingKey {
//        case user_data
//        case access_token
//    }
//}
//
////
////struct Success: Decodable {
////    let token : String
////    let user: User
////}
//
//struct user_data: Codable {
//    let email: String
////    let phone: String
////    let name: String
////    let role_id: Int
////    let updated_at: String
////    let created_at: String
//    let id: Int
////    let active: Int
//
//    enum CodingKeys: CodingKey {
//      case email,
////        phone,
////        name,
////        role_id,
////        updated_at,
////        created_at,
//        id
//       // ,active
//    }
//}


struct SignupResponse: Codable {
    let accessToken, tokenType, expiresAt: String
    let userData: User_Data//UserData
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresAt = "expires_at"
        case userData = "user_data"
    }
}

// MARK: - UserData
struct UserData: Codable {
    let email, updatedAt, createdAt: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case email
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
