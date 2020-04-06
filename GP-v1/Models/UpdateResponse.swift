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
//

