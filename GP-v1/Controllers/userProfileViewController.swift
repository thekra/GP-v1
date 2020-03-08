//
//  userProfileViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 30/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class userProfileViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var chooseCity: UITextField!
    @IBOutlet weak var chooseNeighborhood: UITextField!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let picker1: UIPickerView! = UIPickerView()
    let picker2: UIPickerView! = UIPickerView()
    
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    
    var name = ""
    var phone = ""
    
    var cityArr = [City]()
    var NeiArr = [Neighborhood]()
    var cityID = 0
    var neighboorhoodID = 0
    var selectedNeighborhood: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        profileView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        //.layer.cornerRadius = 30
        scrollView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        //.layer.cornerRadius = 30
        
        getUserInfo()
        createPicker()
        getCityList()
        getNeighborhoodList()
    }
    
    func createPicker() {
        picker1.delegate = self
        picker1.dataSource = self
        
        picker2.delegate = self
        picker2.dataSource = self
        
        chooseCity.inputView = picker1
        chooseCity.inputAccessoryView = createToolBar()
        
        chooseNeighborhood.inputView = picker2
        chooseNeighborhood.inputAccessoryView = createToolBar()
    }
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getUserInfo() {
        
        let urlString = "http://www.ai-rdm.website/api/auth/user"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        
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
                let responseObject =  try decoder.decode(User.self, from: data)
                
                if let uName = responseObject.name {
                    self.userName.text = uName
                    self.name = uName
                    
                } else {
                    
                    self.userName.text = ""
                }
                
                if let uPhone = responseObject.phone {
                    self.userPhone.text = uPhone
                    self.phone = uPhone
                } else {
                    self.userPhone.text = ""
                }
                
                self.userEmail.text = responseObject.email
                
                print("User Info: \(responseObject)")
                
                
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
        }
        
    }
    
    @IBAction func saveUpdates(_ sender: Any) {
        let urlString = "http://www.ai-rdm.website/api/user/update"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        let parameters = [
            "name": userName.text,
            "phone": userPhone.text
            //            "city": self.cityID,
            //            "neighborhood": self.neighboorhoodID
            ] as [String : AnyObject]
        
        
        //        switch self.neighboorhoodID {
        //        case 3377...3437:
        //            print("passed")
        //        default:
        //            print("The neighborhood must be between 3377 and 3437.")
        //            self.showAlert(title: "خطأ", message: "الرجاء اختيار حي")
        //        }
        
        if Connectivity.isConnectedToInternet {
            
            if self.name == self.userName.text || self.phone == self.userPhone.text {
                self.showAlert(title: "تنبيه", message: "لا يوجد ما يتم تحديثه")
                
            } else {
                
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
                                let responseObject =  try decoder.decode(UpdateResponse.self, from: data)
                                print("response Object MESSAGE: \([responseObject].self)")
                                
                                let name = responseObject.userInfo.name
                                
                                let phone = responseObject.userInfo.phone
                                self.name = name
                                self.phone = phone
                                UserDefaults.standard.set(name, forKey: "name")
                                
                                UserDefaults.standard.set(phone, forKey: "phone")
                                
                                
                                
                            } // end of do
                            catch let parsingError {
                                print("Error", parsingError)
                            } // End of catch
                            
                        } // End of upload
                        
                        upload.responseJSON { response in
                            
                            //                        if  let statusCode = response.response?.statusCode{
                            //
                            //                            if(statusCode == 201){
                            //                                //internet available
                            //                            }
                            //                        }else{
                            //                            //internet not available
                            //
                            //                        }
                            print("the resopnse code is : \(response.response?.statusCode ?? 0)")
                            
                            self.showAlert(title: "نجاح", message: "تم تحديث بياناتك!")
                            
                            // من هنا يطلع رسالة الايرور تمام
                            print("the response is : \(response)")
                        }
                        
                    case .failure(let encodingError):
                        // hide progressbas here
                        print("ERROR RESPONSE: \(encodingError)")
                    }
                }) // End of Alamofire
            } // End of else
            
        } // End of Connection check
        else {
            self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
        } // end of else connection
        
    }
    
    func getNeighborhoodList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/neighborhoods"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            
            print(response.response!)
            
            guard let data = response.data else {
                
                DispatchQueue.main.async {
                    print(response.error!)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject =  try decoder.decode([Neighborhood].self, from: data)
                print("response Object MESSAGE: \(responseObject.self)")
                self.NeiArr = responseObject.self
                print("NeiArr\(self.NeiArr)")
                self.chooseNeighborhood.text = responseObject[0].nameAr
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
            DispatchQueue.main.async {
                self.picker2.reloadComponent(0)
            }
        }
    }
    
    func getCityList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/cities"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            
            print(response.response!)
            
            guard let data = response.data else {
                
                DispatchQueue.main.async {
                    print(response.error!)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject =  try decoder.decode(City.self, from: data)
                print("response Object MESSAGE: \(responseObject.self)")
                self.cityArr = [responseObject.self]
                print("CityArr\(self.cityArr)")
                self.chooseCity.text = responseObject.cities[0].nameAr
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
            DispatchQueue.main.async {
                self.picker1.reloadComponent(0)
            }
        }
    }
}

extension userProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == picker1 {
            count = cityArr.count
        } else
            
            if pickerView == picker2 {
                count = NeiArr.count
        }
        return count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var name = ""
        if pickerView == picker1 {
            name = cityArr[row].cities[0].nameAr
        } else
            
            if pickerView == picker2 {
                name = NeiArr[row].nameAr
        }
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker1 {
            self.cityID = Int(NeiArr[row].cityID)!
            print("City ID: \(self.cityID)")
            
            selectedNeighborhood = cityArr[row].cities[0].nameAr
            chooseNeighborhood.text = selectedNeighborhood
        } else
            if pickerView == picker2 {
                
                self.neighboorhoodID = NeiArr[row].id
                print("Nei ID: \(self.neighboorhoodID)")
                
                selectedNeighborhood = NeiArr[row].nameAr
                chooseNeighborhood.text = selectedNeighborhood
        }
    }
}
