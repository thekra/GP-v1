//
//  signinModel.swift
//  GP-v1
//
//  Created by Thekra Faisal on 07/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

struct Signin: Codable {
    let email: String
    let password: String
    //let name, phone: String
    
    enum CodingKeys: CodingKey {
        case email, password
        //, name, phone
    }
}
