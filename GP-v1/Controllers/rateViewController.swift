//
//  rateViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class rateViewController: UIViewController {
    
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var textV: UITextView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateView: UIView!
    
    var ticket: TicketCell?
    var stars = [UIImageView]()
    var starsRating = 0
     var token: String = UserDefaults.standard.string(forKey: "access_token")!
    var ticket_id = 0
    var ratingCount = 0
    var imagesCount = 0
    var picArr = [UIImageView]()
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        loadImages()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textV.layer.cornerRadius = 20
        rateView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        self.imagesCount = (ticket?[0].photos.count)!
        stars = [star1, star2, star3, star4, star5]
        picArr = [pic_1, pic_2, pic_3, pic_4 ,pic_1, pic_2, pic_3, pic_4]

        allPic()
        set(rating: starsRating)
        GlobalV.glovalVariable.starsRating = self.starsRating
        rateButton.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        print("load \(ratingCount)")
        loadImages()
    }
    
    func loadImages() {
        
        for k in 0..<self.imagesCount {
            print("imagesCount \(imagesCount)")
            for i in (ticket?[0].photos[k].roleID)! {
                if i == "3" {
                    let img_name = ticket?[0].photos[k].photoName
                    setImage(img: img_name!, count: k)
                }
            }
        }
    }
    
    func setImage(img: String, count: Int)  {
        let urlString = "http://www.ai-rdm.website/storage/photos/\(img)"
        
         let i = self.startAnActivityIndicator()
        
    if Connectivity.isConnectedToInternet {
        Alamofire.request(urlString, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            print("Image: \(image)")
            // Do stuff with your image
            if case .success(let image) = response.result {
                i.stopAnimating()
                print("image downloaded: \(image)")
                
                       self.picArr[count].image =  image

            }
            }
            
        } // end of interent check
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
    
    
    @IBAction func backToTicket(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ticketInfo") as! TicketInfoViewController
        
                vc.ticket = self.ticket
                self.present(vc, animated: true, completion: nil)
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
            //self.showAlert(title: "تنبيه", message: "الرجاء تعبئة حقل التعليق")
            AlertView.instance.showAlert(message: "الرجاء تعبئة حقل التعليق", alertType: .failure)
                       self.view.addSubview(AlertView.instance.ParentView)
        } else // new
        if self.starsRating == 0 {
            //self.showAlert(title: "تنبيه", message: "الرجاء تحديد التقييم")
            AlertView.instance.showAlert(message: "الرجاء تحديد التقييم", alertType: .failure)
            self.view.addSubview(AlertView.instance.ParentView)
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
                        if response.response?.statusCode == 200 {
                        i.stopAnimating()
                       // self.showAlert(title: "نجاح", message: "تم ارسال تقييمك بنجاح!")
                            AlertView.instance.showAlert(message: "تم ارسال تقييمك بنجاح", alertType: .success)
                            self.view.addSubview(AlertView.instance.ParentView)
                        self.textV.isEditable = false
                        for i in self.stars {
                            i.isUserInteractionEnabled = false
                        }
                        self.rateButton.isHidden = true
                        }
                        
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
            //self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
            AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
            self.view.addSubview(AlertView.instance.ParentView)
        } // End of Connection check
        
        } // end of else
    }
}
