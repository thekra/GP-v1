//
//  showTicket.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

// MARK: - ShowTicket
struct ShowTicket: Codable {
    let ticket: Ticket
    let location: Location
    let photos: [Photo]
    let ticketHistories: [JSONAny]
    let userRating: [UserRating]
}

// MARK: - Location
struct Location: Codable {
    let id: Int
    let latitude, longitude, city, neighborhood: String
}
//
//// MARK: - Photo
//struct Photo: Codable {
//    let id: Int
//    let photoName, ticketID, roleID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case photoName = "photo_name"
//        case ticketID = "ticket_id"
//        case roleID = "role_id"
//    }
//}
//
//// MARK: - Ticket
//struct Ticket: Codable {
//    let id: Int
//    let ticketDescription, status, statusAr, classification: String
//    let classificationAr, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case ticketDescription = "description"
//        case status
//        case statusAr = "status_ar"
//        case classification
//        case classificationAr = "classification_ar"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - UserRating
//struct UserRating: Codable {
//    let id: Int
//    let rating, comment, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, rating, comment
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
