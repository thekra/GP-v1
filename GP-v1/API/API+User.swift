//
//  API+User.swift
//  GP-v1
//
//  Created by Thekra Faisal on 25/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
//import UIKit
import Alamofire

extension API {
    
    // MARK:- New Ticket
    
    /// takes email and password and returns role id
//    class func userInfo(userName: UITextField,userEmail: UITextField,userPhone:UITextField, chooseNeighborhood: UITextField, chooseCity: UITextField, completion: @escaping (_ error: Error?, _ success: Bool, _ message: String, _ user: User?) -> Void) {
//
//        guard let api_token = helper.getApiToken() else {
//            completion(nil, false, "", nil)
//            return
//        }
//
//    let urlString = URLs.get_user
//
//           let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(api_token)",
//               "Content-Type": "multipart/form-data",
//               "Accept": "application/json"
//           ]
//
//
//
//           Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
//               response in
//               guard let data = response.data else {
//
//                   DispatchQueue.main.async {
//                       print("Response async error \(response.error!)")
//                   }
//                   return
//               }
//               let decoder = JSONDecoder()
//               do {
//                   let responseObject =  try decoder.decode(User.self, from: data)
//
//                   if let uName = responseObject.name {
//                       userName.text = uName
//                    //completion(nil, true, "", uName, "","")
//                   // name.self = uName
//
//
//                   } else {
//
//                       userName.text = ""
//                   }
//
//                   if let uPhone = responseObject.phone {
//                       //let phoneCon = self.convertEngNumToArabicNumm(num: Int(uPhone)!)
//                       userPhone.text = uPhone
//                    //completion(nil, true, "", "", uPhone,"")
//                    //completion(nil, true, "", uPhone)
//                   // phone = uPhone
//                   } else {
//                       userPhone.text = ""
//                   }
//
//                   userEmail.text = responseObject.email
//
//                   if let chosenNei = responseObject.neighborhood?.nameAr{
//
//                   chooseNeighborhood.text = chosenNei
//                   //self.oldSelectedNei = responseObject.neighborhood!.nameAr//chosenNei
//                   }
//
//                   if let chosenCity = responseObject.city?.nameAr {
//
//                  chooseCity.text = chosenCity
//
//                   }
//
//                   if let gender = responseObject.gender {
//                    //completion(nil, true, "", "", "",gender)
////                       if gender == "MALE" {
////                           self.isSelected(button: self.maleB, button2: self.femaleB)
////                       } else if gender == "FEMALE" {
////                           self.isSelected(button: self.femaleB, button2: self.maleB)
////                       }
//                      // Gender = gender
//                   }
//                   //self.neighboorhoodID = responseObject.neighborhood.id
//                completion(nil, true, "", responseObject)
//                   print("User Info: \(responseObject)")
//
//
//               } // end of do
//               catch let parsingError {
//                   print("Error", parsingError)
//               }
//           }
//    }
}
