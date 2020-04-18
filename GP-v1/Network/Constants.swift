//
//  Constants.swift
//  GP-v1
//
//  Created by Thekra Faisal on 19/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

struct URLs {
    
    static let main     = "http://www.ai-rdm.website/"
    static let api      = "api/"
    static let auth     = api + "auth/"
    static let ticket   = api + "ticket/"
    static let user     = api + "user/"
    static let storage  = "storage/photos/"
    // MARK:-  AUTH
    
    /// POST {email, password}
    static let login    = main + auth + "login"
    
    /// POST {email, password, password_confirmation}
    static let register = main + auth + "register"
    
    /// GET {api_token}
    static let logout   = main + auth + "logout"
    
    /// GET {api_token}
    static let get_user = main + auth + "user"
    
    /// POST {email}
    static let reset    = main + api + "password/create"
    
    
    //MARK:- TICKET
    
    /// POST { description, latitude, longitude, cityID, neighborhodID }
    static let new_ticket    = main + ticket + "create"
    
    /// GET {api_token}
    static let tickets_list  = main + ticket + "list"
    
    /// POST { comment, ticket_id, rating }
    static let rate_ticket   = main + ticket + "rate"
    
    /// POST {ticket_id}
    static let delete_ticket = main + ticket + "delete"
    
    /// POST { ticket_id, status, degree_id }
    static let update_ticekt = main + ticket + "update"
    
    /// GET {api_token}
    static let neighborhood  = main + ticket + "neighborhoods"
    
    /// GET {api_token}
    static let cities        = main + ticket + "cities"
    
    /// GET {api_token}
    static let tickets_count = main + ticket + "ticketsCount"
    
    //MARK:- USER
    
    /// POST { name, phone, neighboorhood, gender }
    static let user_update   = main + user + "update"
    
    
    // MARK:- IMAGE
    
    /// GET
    static let get_image     = main + storage
}


