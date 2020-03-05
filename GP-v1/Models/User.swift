//
//  User.swift
//  GP-v1
//
//  Created by Thekra Faisal on 02/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
struct User: Codable {
    let id: Int
    let name, phone: String?//JSONNull?
    //let name: String
    let email, active, role: String
}
