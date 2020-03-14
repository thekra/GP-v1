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
//    let id: Int
//    let name, phone: String?//JSONNull?
//    //let name: String
//    let email, active, role: String
//}
    let id: Int
    let name, phone, email, active, gender: String?
    let role, roleAr: String
    let city, neighborhood: Cityy?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, active, role
        case roleAr = "role_ar"
        case gender, city, neighborhood
    }
}

// MARK: - City
struct Cityy: Codable {
    let id: Int
    let nameAr, nameEn: String
    let cityID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case cityID = "city_id"
    }
}
