//
//  resetPasswordViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 12/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class resetPasswordViewController: UIViewController {
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var emailT: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resetButton.clipsToBounds = true
       bottomView.roundCorner(corners: [.topRight, .topLeft] , radius: 15)
        resetButton.layer.cornerRadius = 20
    }
    
    @IBAction func resetPressed(_ sender: Any) {
       
        let urlString = "http://www.ai-rdm.website/api/password/create"
                
                let headers: HTTPHeaders = [
                    "Content-Type": "multipart/form-data",
                    "Accept": "application/json"
                ]
                
                
                let parameters = [
                    "email": emailT.text
                    ] as [String : AnyObject]
                 let i = self.startAnActivityIndicator()
                if Connectivity.isConnectedToInternet {
                     Alamofire.upload(multipartFormData:
                        { (multipartFormData ) in
                            
                            for (key, value) in parameters {
                                if let temp = value as? String { multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                                    
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
                            
                                                
                            //self.showAlert(title: "تم الارسال", message: "لقد تم ارسال رسالة استعادة كلمة المرور الى بريدك المدخل")
                            
                            
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
                                
                            } // End of upload
                            
                            upload.responseJSON { response in
                                
//                                if  let statusCode = response.response?.statusCode{
                                    
                                    
                                print("the resopnse code is : \(response.response?.statusCode ?? 0)")
                                if response.response?.statusCode == 404 {
                                    i.stopAnimating()
                                    //self.showAlert(title: "خطأ", message: "خطأ في السيرفر")
                                    AlertView.instance.showAlert(message: "البريد المدخل غير موجود", alertType: .failure)
                                    self.view.addSubview(AlertView.instance.ParentView)
                                    
                                }
                                else
                                if response.response?.statusCode == 422 {
                                    i.stopAnimating()
                                //self.showAlert(title: "خطأ", message: "مدخل غير صالح/مدخل مفقود/ الايميل موجود مسبقاً")
                                AlertView.instance.showAlert(message: "مدخل غير صالح/مدخل مفقود", alertType: .failure)
                                                       self.view.addSubview(AlertView.instance.ParentView)
                                } else
                                
                                if response.response?.statusCode == 200 {
                                    i.stopAnimating()
                                    AlertView.instance.showAlert(message:"تم ارسال رسالة استعادة الكلمة السرية الى بريدك المدخل", alertType: .success)
                                    self.view.addSubview(AlertView.instance.ParentView)
                                }
                                // من هنا يطلع رسالة الايرور تمام
                                print("the response is : \(response)")
                            }
                            
                        case .failure(let encodingError):
                            // hide progressbas here
                            print("ERROR RESPONSE: \(encodingError)")
                        }
                    }) // End of Alamofire
                    
                    
                } // End of Connection check
                else {
                    //self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
                    i.stopAnimating()
                    AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
                    self.view.addSubview(AlertView.instance.ParentView)
                }
    }
    
}
