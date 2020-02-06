//
//  signup.swift
//  GP-v1
//
//  Created by Thekra Faisal on 11/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

struct signup: Codable {
    let email: String
    let password: String
    let password_conformation: String
    let mobile: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case email, password, password_conformation, mobile, name
    }
}
