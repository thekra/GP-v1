//
//  TicketResponse.swift
//  GP-v1
//
//  Created by Thekra Faisal on 20/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

//struct Ticket: Codable {
////    let description: String
////    let photos: [String]
////    let latitude: Double
////    let longitude: Double
////    let city: Int
////    let neighborhood: Int
////
////    enum CodingKeys: CodingKey {
////        case description, photos,
////        latitude,
////        longitude,
////        city,
////        neighborhood
////    }
//     let message: String
//    let errors: Errors
//}
////
////    }
////
//    // MARK: - Errors
//
//struct Errors: Codable {
//       let latitude, longitude, city, neighborhood: [String]
//        let photos: [String]
//
//        enum CodingKeys: String, CodingKey {
//            case errorsDescription = "photos"
//            //case errors
//        }
//
//    }



// MARK: - Ticket
struct TicketResponse: Codable {
    let message: String
    let errors: Errors
}

// MARK: - Errors
struct Errors: Codable {
    let latitude, longitude, city, neighborhood: [String]
    let photos: [String]
}
