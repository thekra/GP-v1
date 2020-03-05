//
//  signinResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 08/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
// MARK: - SigninResponse

//struct signinResponse: Codable {
//   // let success: Success
//    let access_token : String
//    let user_data: userData
////    let user: Users
//   //let accessToken, tokenType, expiresAt: String
////
//    enum CodingKeys: CodingKey {
//        case user_data
//        case access_token
////        case token_type
////        case expires_at
//    }
//}
//
//struct userData: Codable {
//let email: String
//let phone: String
//let name: String
//let role_id: Int
//let updated_at: String
//let created_at: String
//let id: Int
//let active: Int
//
//enum CodingKeys: String, CodingKey {
//  case email,
//    phone,
//    name,
//    role_id,
//    updated_at,
//    created_at,
//    id,
//    active
//}
//}



//struct Success: Decodable {
//    let access_token : String
//    let user_data: user_data
//}


// MARK: - User
/*struct Users: Codable {
 let id: Int
 let name, email, gender, age: String
 let isCompany, type: String
 let emailVerifiedAt: JSONNull?
 let createdAt, updatedAt: String
 
 enum CodingKeys: String, CodingKey {
 case id, name, email, gender, age, isCompany, type
 case emailVerifiedAt = "email_verified_at"
 case createdAt = "created_at"
 case updatedAt = "updated_at"
 }
 }
 
 
 // MARK: - Encode/decode helpers
 
 class JSONNull: Codable, Hashable {
 
 public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
 return true
 }
 
 public var hashValue: Int {
 return 0
 }
 
 public init() {}
 
 public required init(from decoder: Decoder) throws {
 let container = try decoder.singleValueContainer()
 if !container.decodeNil() {
 throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
 }
 }
 
 public func encode(to encoder: Encoder) throws {
 var container = encoder.singleValueContainer()
 try container.encodeNil()
 }
 }*/



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
    //let phone: JSONNull?
    let name, phone: String?
    let email, active, roleID: String
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
    
}
