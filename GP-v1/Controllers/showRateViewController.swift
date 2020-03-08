//
//  showRateViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class showRateViewController: UIViewController {

    @IBOutlet weak var showRatingView: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var comment: UITextView!

    var ticket_id = 0
    var starsRating = 0
     var stars = [UIImageView]()
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.layer.cornerRadius = 20
        showRatingView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        stars = [star1, star2, star3, star4, star5]
        showRating()
    }
    
    func set(rating: Int) {
           for i in stars {
               if i.tag > rating {
                   i.image = UIImage(named: "Icon ionic-ios-star-unfill")
               }else{
                   i.image = UIImage(named: "Icon ionic-ios-star")
               }
           }
       }
    
    func showRating() {
        let urlString = "http://www.ai-rdm.website/api/ticket/show"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        let parameters = [
            "ticket_id": self.ticket_id
        ] as [String : AnyObject]


         if Connectivity.isConnectedToInternet {
                      
                      Alamofire.upload(multipartFormData:
                          { (multipartFormData ) in
                              
                              for (key, value) in parameters {
                                  if let temp = value as? Int {
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
                                  
                                  guard let data = response.data else {
                                      
                                      DispatchQueue.main.async {
                                          print(response.error!)
                                      }
                                      return
                                  }
                                  let decoder = JSONDecoder()
                                  do {
                                    let responseObject =  try decoder.decode(ShowTicket.self, from: data)
                                      print("response Object MESSAGE: \(responseObject)")
                                      
                                    self.starsRating = Int(responseObject.userRating[0].rating)!
                                    if self.starsRating == 1 {
                                        self.set(rating: 1)
                                          
                                    } else if self.starsRating == 2 {
                                        self.set(rating: 2)
                                          
                                    } else if self.starsRating == 3 {
                                        self.set(rating: 3)
                                          
                                    } else if self.starsRating == 4 {
                                        self.set(rating: 4)
                                          
                                    } else if self.starsRating == 5 {
                                        self.set(rating: 5)
                                                      }
                                    self.comment.text = responseObject.userRating[0].comment
                                    print(self.comment.text!)
                                    print("Stars \(self.starsRating)")
                                  } // end of do
                                  catch let parsingError {
                                      print("Error", parsingError)
                                  } // End of catch
                                  
                              } // End of upload
                              
                              upload.responseJSON { response in
                                                       
                                  print("the resopnse code is : \(response.response?.statusCode ?? 0)")            // من هنا يطلع رسالة الايرور تمام
                                  print("the response is : \(response)")
                              }
                              
                          case .failure(let encodingError):
                              // hide progressbas here
                              print("ERROR RESPONSE: \(encodingError)")
                          }
                      }) // End of Alamofire
                 
                  
              } // End of Connection check
              else {
                  self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
              }
    }

}
