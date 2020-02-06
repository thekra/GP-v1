//
//  signinResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 08/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
// MARK: - SigninResponse
struct signinResponse: Decodable {
    let success: Success
//    let user: Users
   //let accessToken, tokenType, expiresAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case user
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//        case expiresAt = "expires_at"
    }
//}
struct Success: Decodable {
    let token : String
    let user: User
}
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
