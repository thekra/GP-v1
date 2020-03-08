//
//  rateViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class rateViewController: UIViewController {
    
    @IBOutlet weak var textV: UITextView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    var stars = [UIImageView]()
    var starsRating = 0
     var token: String = UserDefaults.standard.string(forKey: "access_token")!
    var ticket_id = 0
    
    @IBOutlet weak var rateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textV.layer.cornerRadius = 20
        stars = [star1, star2, star3, star4, star5]
        
        pic(sender: star1)
        pic(sender: star2)
        pic(sender: star3)
        pic(sender: star4)
        pic(sender: star5)
        
        set(rating: starsRating)
    }
    
    func pic(sender: UIImageView!) {
        switch sender.tag {
            
        case 1:
            setupPic(pic: star1, action: #selector(self.imageTap))
            
        case 2:
            setupPic(pic: star2, action: #selector(self.imageTap2))
            
        case 3: setupPic(pic: star3, action: #selector(self.imageTap3))
            
        case 4: setupPic(pic: star4, action: #selector(self.imageTap4))
            
        case 5: setupPic(pic: star5, action: #selector(self.imageTap5))
            
        default: break
            //setupPic(pic: star1, action: #selector(self.imageTap(sender:)))
        }
    }
    
    func setupPic(pic: UIImageView!, action: Selector){
        pic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        pic.isUserInteractionEnabled = true
        
    }
    func set(rating: Int) {
        self.starsRating = rating
        for i in stars {
            if i.tag > starsRating {
                i.image = UIImage(named: "Icon ionic-ios-star-unfill")
            }else{
                i.image = UIImage(named: "Icon ionic-ios-star")
            }
        }
    }
    
    @objc func imageTap() {
        print("image  clicked")
        set(rating: 1)
        
    }
    
    @objc func imageTap2() {
        print("image 2 clicked")
        set(rating: 2)
    }
    
    @objc func imageTap3() {
        print("image 3 clicked")
        set(rating: 3)
    }
    
    @objc func imageTap4() {
        print("image 4 clicked")
        set(rating: 4)
    }
    
    @objc func imageTap5() {
        print("image 5 clicked")
        set(rating: 5)
    }
    
    
    
    @IBAction func ratePressed(_ sender: Any) {
        let urlString = "http://www.ai-rdm.website/api/ticket/rate"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        let parameters = [
            "comment": "textV.text!",
            "ticket_id": ticket_id,
            "rating": self.starsRating
            ] as [String : AnyObject]
        
        
        if Connectivity.isConnectedToInternet {
            Alamofire.upload(multipartFormData:
                { (multipartFormData ) in
                  
                    
                    for (key, value) in parameters {
                        
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                        }
                        
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
                        self.showAlert(title: "نجاح", message: "تم ارسال تقييمك بنجاح!")
                        self.rateButton.isHidden = true
                        
                    } // End of upload
                    
                    upload.responseJSON { response in
                        
                        if  let statusCode = response.response?.statusCode{
                            
                            if(statusCode == 201){
                                //internet available
                            }
                        }else{
                            //internet not available
                            
                        }
                        print("the resopnse code is : \(response.response?.statusCode)")
                        
                        // من هنا يطلع رسالة الايرور تمام
                        print("the response is : \(response)")
                    }
                    
                case .failure(let encodingError):
                    // hide progressbas here
                    print("ERROR RESPONSE: \(encodingError)")
                }
            })
            
            
        } // End of Connection check
        else {
            self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
        } // end of else
    }
}
