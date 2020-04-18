//
//  helper.swift
//  GP-v1
//
//  Created by Thekra Faisal on 25/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation

class helper: NSObject {
     class func saveApiToken(token: String) {
           // save api token to UserDefaults
           let def = UserDefaults.standard
           def.set(token, forKey: "access_token")
           def.synchronize()
           
       }
    
    class func saveName(name: String) {
              // save user name to UserDefaults
              let def = UserDefaults.standard
              def.set(name, forKey: "name")
              def.synchronize()
              
          }
    
    class func savePhone(phone: String) {
              // save user phone to UserDefaults
              let def = UserDefaults.standard
              def.set(phone, forKey: "phone")
              def.synchronize()
              
          }

       class func getApiToken() -> String? {
           let def = UserDefaults.standard
        return def.string(forKey: "access_token")
       }
}
