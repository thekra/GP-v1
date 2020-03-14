//
//  userProfileViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 30/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class userProfileViewController: UIViewController{
    
    
    
    @IBOutlet weak var startUpdate: UIButton!
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
    var selectedCity: String?
    //var oldSelectedNei = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
//        profileView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
//        //.layer.cornerRadius = 30
//        scrollView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        //.layer.cornerRadius = 30
        getUserInfo()
        setUI(flag: false, button: updateButton, button2: startUpdate)
        createPicker()
        getCityList()
        getNeighborhoodList()
    }
    func setUI(flag: Bool, button: UIButton, button2: UIButton) {
        button.isHidden = true
        button2.isHidden = false
        userName.isUserInteractionEnabled = flag
        userPhone.isUserInteractionEnabled = flag
        chooseNeighborhood.isUserInteractionEnabled = flag
        if flag == false {
            userName.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            userPhone.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            chooseNeighborhood.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            userName.backgroundColor = #colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1)
            userPhone.backgroundColor = #colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1)
            chooseNeighborhood.backgroundColor = #colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1)
        }
        chooseCity.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chooseCity.isUserInteractionEnabled = false
        userEmail.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        updateButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        startUpdate.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        profileView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        scrollView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        }
    
    @IBAction func startupdate(_ sender: Any) {
        setUI(flag: true, button: startUpdate, button2: updateButton)
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
                    //let phoneCon = self.convertEngNumToArabicNumm(num: Int(uPhone)!)
                    self.userPhone.text = uPhone
                    self.phone = uPhone
                } else {
                    self.userPhone.text = ""
                }
                
                self.userEmail.text = responseObject.email
                
                if let chosenNei = responseObject.neighborhood?.nameAr{
                    
                self.chooseNeighborhood.text = chosenNei
                //self.oldSelectedNei = chosenNei
                }
                
                if let chosenCity = responseObject.city?.nameAr {
                    
                self.chooseCity.text = chosenCity
                    
                }
                //self.neighboorhoodID = responseObject.neighborhood.id
                print("User Info: \(responseObject)")
                
                
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
        }
        
    }
    
    @IBAction func saveUpdates(_ sender: Any) {
        let urlString = "http://www.ai-rdm.website/api/user/update"
        var parameters = [:] as [String : AnyObject]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        if userName.text != "" {
            parameters["name"] = userName.text! as AnyObject
        }

        if userPhone.text != "" {
            parameters["phone"] =  userPhone.text! as AnyObject
        }
        
        if neighboorhoodID != 0 {
            parameters["neighborhood"] = self.neighboorhoodID  as AnyObject
        }

        if parameters.isEmpty {
            AlertView.instance.showAlert(message: "لا يوجد ما يتم تحديثه!", alertType: .failure)
            self.view.addSubview(AlertView.instance.ParentView)
        }
        
        //        switch self.neighboorhoodID {
        //        case 3377...3437:
        //            print("passed")
        //        default:
        //            print("The neighborhood must be between 3377 and 3437.")
        //            self.showAlert(title: "خطأ", message: "الرجاء اختيار حي")
        //        }
        
         let i = self.startAnActivityIndicator()
        if Connectivity.isConnectedToInternet {
            
                Alamofire.upload(multipartFormData:
                    { (multipartFormData ) in
                        
                        for (key, value) in parameters {
                            if let temp = value as? String { multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                                
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
                            
                            guard let data = response.data else {
                                
                                DispatchQueue.main.async {
                                    print(response.error!)
                                }
                                return
                            }
                            let decoder = JSONDecoder()
                            do {
                                let responseObject =  try decoder.decode(User.self, from: data)
                                print("response Object MESSAGE: \([responseObject].self)")
                                
                                let name = responseObject.name
                                
                                if name!.components(separatedBy: " ").filter({ !$0.isEmpty}).count == 1 {
                                    
                                    print("One word")
                                    self.name = name!
                                UserDefaults.standard.set(name, forKey: "name")

                                } else {
                                    print("Not one word")
                                    let firstName = name!.components(separatedBy: " ")
                                    self.name = firstName[0]
                                    UserDefaults.standard.set(firstName[0], forKey: "name")
                                }
                                
                                let phone = responseObject.phone
                                //let convertedPhone = self.convertEngNumToArabicNumm(num: Int(phone)!)
                                //self.name = name
                                self.phone = phone!
                                
                                //UserDefaults.standard.set(name, forKey: "name")
                                
                                UserDefaults.standard.set(phone, forKey: "phone")
                                self.chooseNeighborhood.text = responseObject.neighborhood?.nameAr
                                //self.chooseNeighborhood.text = self.selectedNeighborhood
                                //self.neighboorhoodID = responseObject.neighborhood.id
                                
                            } // end of do
                            catch let parsingError {
                                print("Error", parsingError)
                            } // End of catch
                            
                        } // End of upload
                        
                        upload.responseJSON { response in
                            
                            print("the resopnse code is : \(response.response?.statusCode ?? 0)")
                            if response.response?.statusCode == 200 {
                            i.stopAnimating()
                            //self.showAnAlert()
                                           AlertView.instance.showAlert(message: "تم تحديث بياناتك", alertType: .success)
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "userProfilee") as! userProfileViewController
                                vc.view.addSubview(AlertView.instance.ParentView)
                                           self.present(vc, animated: true, completion: nil)
                            }
                            if response.response?.statusCode == 422 {
                                
                            }
                            
                            // من هنا يطلع رسالة الايرور تمام
                            print("the response is : \(response)")
                        }
                        
                    case .failure(let encodingError):
                        // hide progressbas here
                        print("ERROR RESPONSE: \(encodingError)")
                    }
                }) // End of Alamofire
            //} // End of else
            
        } // End of Connection check
        else {
            i.stopAnimating()
           // self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
            
                       AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
                       self.view.addSubview(AlertView.instance.ParentView)
        } // end of else connection
        
    }
    
    
    func getNeighborhoodList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/neighborhoods"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        if Connectivity.isConnectedToInternet {

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
    }
    
    func getCityList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/cities"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        if Connectivity.isConnectedToInternet {

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
            self.cityID = Int(cityArr[row].cities[row].id)
            print("City ID: \(self.cityID)")

            selectedCity = cityArr[row].cities[row].nameAr
            chooseCity.text = selectedCity
        } else
            if pickerView == picker2 {
                
                self.neighboorhoodID = NeiArr[row].id
                print("Nei ID: \(self.neighboorhoodID)")
                
                selectedNeighborhood = NeiArr[row].nameAr
                chooseNeighborhood.text = selectedNeighborhood
        }
    }
}
