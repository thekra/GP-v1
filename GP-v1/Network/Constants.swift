//
//  Constants.swift
//  GP-v1
//
//  Created by Thekra Faisal on 19/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import Alamofire

struct URLs {
    
    static let main     = "http://www.ai-rdm.website/"
    static let api      = "api/"
    static let auth     = "auth/"
    static let ticket   = "ticket/"
    static let storage  = "storage/photos/"
    static let user     = "user/"
    // MARK:-  AUTH
    
    /// POST {email, password}
    static let login    = main + api + auth + "login"
    
    /// POST {email, password, password_confirmation}
    static let register = main + api + auth + "register"
    
    /// GET {api_token}
    static let logout   = main + api + auth + "logout"
    
    /// GET {api_token}
    static let get_user = main + api + auth + "user"
    
    /// POST {email}
    static let reset    = main + api + "password/create"
    
    
    //MARK:- TICKET
    
    /// POST { description, latitude, longitude, cityID, neighborhodID }
    static let new_ticket    = main + api + ticket + "create"
    
    /// GET {api_token}
    static let tickets_list  = main + api + ticket + "list"
    
    /// POST { comment, ticket_id, rating }
    static let rate_ticket   = main + api + ticket + "rate"
    
    /// POST {ticket_id}
    static let delete_ticket = main + api + ticket + "delete"
    
    /// POST { ticket_id, status, degree_id }
    static let update_ticekt = main + api + ticket + "update"
    
    /// GET {api_token}
    static let neighborhood  = main + api + ticket + "neighborhoods"
    
    /// GET {api_token}
    static let cities        = main + api + ticket + "cities"
    
    /// GET {api_token}
    static let tickets_count = main + api + ticket + "ticketsCount"
    
    //MARK:- USER
    
    /// POST { name, phone, neighboorhood, gender }
    static let user_update   = main + api + user + "update"
    
    
    // MARK:- IMAGE
    
    /// GET
    static let get_image     = main + storage
}


