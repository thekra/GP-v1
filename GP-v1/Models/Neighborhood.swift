//
//  Neighborhood.swift
//  GP-v1
//
//  Created by Thekra Faisal on 25/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

//// MARK: - NeighborhoodElement
//struct Neighborhood: Codable {
//    let id: Int
//    let nameAr, nameEn, cityID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//        case cityID = "city_id"
//    }
//}


// MARK: - Neighborhood
struct Neighborhood: Codable {
    let neighborhoods: [NeighborhoodElement]
}

// MARK: - NeighborhoodElement
struct NeighborhoodElement: Codable {
    let id: Int
    let nameAr, nameEn, cityID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case cityID = "city_id"
    }
}
