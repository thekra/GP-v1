//
//  signupResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 11/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
// MARK: - SignupResponse

//struct signupResponse: Decodable {
//    let success: Success
//}
//
//struct Success: Decodable {
//    let token : String
//    let user: User
//}

struct User: Decodable {
    let email: String
    let mobile: String,
    name: String,
    role_id: Int,
    updated_at: String,
    created_at: String,
    id: Int
}
