//
//  TicketID.swift
//  GP-v1
//
//  Created by Thekra Faisal on 27/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

struct TicketID: Codable {
    let ticket_id: Int
    
    
    enum CodingKeys: CodingKey {
        case ticket_id
    }
}
