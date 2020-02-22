//
//  City.swift
//  GP-v1
//
//  Created by Thekra Faisal on 25/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

// MARK: - City
struct City: Codable {
    let cities: [CityElement]
}

// MARK: - CityElement
struct CityElement: Codable {
    let id: Int
    let nameAr, nameEn: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}
