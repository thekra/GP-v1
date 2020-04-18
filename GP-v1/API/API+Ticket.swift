//
//  API+Ticket.swift
//  GP-v1
//
//  Created by Thekra Faisal on 20/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import Alamofire

extension API {
    
    // MARK:- New Ticket
    
    /// takes email and password and returns role id
    class func newTicket(decription: UITextView, latitude: Double, longitude: Double, cityID: Int, neighborhoodID: Int, imgArr: [Data], completion: @escaping (_ error: Error?, _ success: Bool, _ message: String) -> Void) {
        
        guard let api_token = helper.getApiToken() else {
            completion(nil, false, "")
            return
        }
        
        let urlString = URLs.new_ticket
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(api_token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        var parameters = [:] as [String : AnyObject]
        if decription.text != "" {
            parameters["description"] = decription.text! as AnyObject
        }
        
         parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "city": cityID,
            "neighborhood": neighborhoodID
            ] as [String : AnyObject]
        
        //if Connectivity.isConnectedToInternet {
            Alamofire.upload(multipartFormData:
                { (multipartFormData ) in
                    
                    for i in 0..<imgArr.count {
                        multipartFormData.append(
                            imgArr[i] ,
                            withName: "photos[\(i)]",
                            fileName: "swift_file_\(i).jpeg",
                            mimeType: "image/jpeg"
                        )

                    }
                    
                    for (key, value) in parameters {
                        
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                        }
                        
                        if let temp = value as? Int {
                            multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                        }
                        
                        if let temp = value as? Double {
                            multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                        }
                        
                        print("Sent Parameters: \(parameters)")
                    }
            }, to: urlString,
               method: .post,
               headers: headers,
               encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        debugPrint(response.debugDescription)
                        print("REsponse: \(response)")
                        
                        if response.response?.statusCode == 200 {
                            DispatchQueue.main.async {
                                completion(nil, true, "sucess")
                            }
                        }
                            
                        guard let data = response.data else {
                            
                            DispatchQueue.main.async {
                                print(response.error!)
                            }
                            return
                        }
                        
                        let decoder = JSONDecoder()
                        do {
                            let responseObject =  try decoder.decode(TicketResponse.self, from: data)
                            print("response Object MESSAGE: \([responseObject].self)")
                            
                        } // end of do
                        catch let parsingError {
                            print("Error", parsingError)
                        } // End of catch
                        
                    } // End of upload
                    
                    upload.responseJSON { response in
                        
                        
                        print("the resopnse code is : \(response.response?.statusCode)")
                        
                        // من هنا يطلع رسالة الايرور تمام
                        print("the response is : \(response)")
                    }
                    
                case .failure(let encodingError):
                    // hide progressbas here
                    print("ERROR RESPONSE: \(encodingError)")
                }
            })
            
        
    }
    
    // MARK:- List Tickets
       
       /// takes email and password and returns role id
    class func listTickets(tableView:UITableView, completion: @escaping (_ error: Error?, _ success: Bool, _ ticket: TicketCell, _ message: String) -> Void) {
           
           guard let api_token = helper.getApiToken() else {
               completion(nil, false, [] ,"")
               return
           }
           
           let urlString = URLs.tickets_list
           let headers: HTTPHeaders = [
               "Authorization": "Bearer \(api_token)",
               "Content-Type": "multipart/form-data",
               "Accept": "application/json"
           ]
        if Connectivity.isConnectedToInternet {
                Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
                    response in
                    
                    guard let data = response.data else {
                        
                        DispatchQueue.main.async {
                            print("Response async error \(response.error!)")
                        }
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let responseObject =  try decoder.decode(TicketCell.self, from: data)
                        if response.response?.statusCode == 200 {
                            
                                                   
//                                                   if ticketCell.isEmpty {
//                                                       labelView.isHidden = false
//                                                   }
                            DispatchQueue.main.async {
                                completion(nil, true, responseObject,"")
                            }
                        }
                       
                        
                    } // end of do
                    catch let parsingError {
                        print("Error", parsingError)
                    }
                    
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        
                    }
                } // end of alamofire
                
            } else {
             completion(nil, false, [] ,"لا يوجد اتصال بالانترنت")
            } // end of else connection
            
        } // end of function
    
    }


