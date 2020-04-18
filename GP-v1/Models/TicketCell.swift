// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ticketCell = try? newJSONDecoder().decode(TicketCell.self, from: jsonData)

import Foundation

// MARK: - TicketCellElement
struct TicketCellElement: Codable {
    let ticket: Ticket
    let location: [Location]
    let photos: [Photo]
    let ticketHistories: [TicketHistory]
    let userRating: [UserRating]
}

// MARK: - Location
struct Location: Codable {
    let id: Int
    let latitude, longitude, city, neighborhood: String
}


// MARK: - Photo
struct Photo: Codable {
    let id: Int
    let photoName, ticketID, roleID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoName = "photo_name"
        case ticketID = "ticket_id"
        case roleID = "role_id"
    }
}

// MARK: - TicketHistory
struct TicketHistory: Codable {
    let id: Int
    let massage, sender, receiver, ticketID: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, massage, sender, receiver
        case ticketID = "ticket_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - UserRating
struct UserRating: Codable {
    let id: Int
    let rating, comment, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, rating, comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - Ticket
struct Ticket: Codable {
    let id: Int
    let ticketDescription, status, statusAr: String?
    let classification, classificationAr, degree, degreeAr, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ticketDescription = "description"
        case status
        case statusAr = "status_ar"
        case degree
        case degreeAr = "degree_ar"
        case classification
        case classificationAr = "classification_ar"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias TicketCell = [TicketCellElement]
