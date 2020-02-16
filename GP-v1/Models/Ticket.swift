//
//  Ticket.swift
//  GP-v1
//
//  Created by Thekra Faisal on 20/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

struct Ticket: Codable {
    let description: String
    let photos: [String]
    let latitude: Double
    let longitude: Double
    let city: Int
    let neighborhood: Int
    
    enum CodingKeys: CodingKey {
        case description, photos,
        latitude,
        longitude,
        city,
        neighborhood
    }
}
