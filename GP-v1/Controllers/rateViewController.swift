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
    @IBOutlet weak var rateButton: UIButton!
    
    var stars = [UIImageView]()
    var starsRating = 0
     var token: String = UserDefaults.standard.string(forKey: "access_token")!
    var ticket_id = 0
    var ratingCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textV.layer.cornerRadius = 20
        stars = [star1, star2, star3, star4, star5]
        
        
        allPic()
        set(rating: starsRating)
        GlobalV.glovalVariable.starsRating = self.starsRating
        rateButton.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        print("load \(ratingCount)")
        
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
    
    func allPic() {
            pic(sender: star1)
            pic(sender: star2)
            pic(sender: star3)
            pic(sender: star4)
            pic(sender: star5)
        //}
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
            "comment": textV.text!,
            "ticket_id": ticket_id,
            "rating": self.starsRating
            ] as [String : AnyObject]
        
         let i = self.startAnActivityIndicator()
        
        if textV.text == "" {
            self.showAlert(title: "تنبيه", message: "الرجاء تعبئة حقل التعليق")
        } else // new
        if self.starsRating == 0 {
            self.showAlert(title: "تنبيه", message: "الرجاء تحديد التقييم")
        }
        else {
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
                        i.stopAnimating()
                        self.showAlert(title: "نجاح", message: "تم ارسال تقييمك بنجاح!")
                        self.textV.isEditable = false
                        for i in self.stars {
                            i.isUserInteractionEnabled = false
                        }
                        self.rateButton.isHidden = true
                        
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
        else {
            i.stopAnimating()
            self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")

        } // End of Connection check
        
        } // end of else
    }
}
