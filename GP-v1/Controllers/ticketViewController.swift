//
//  ticketViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class ticketViewController:  UIViewController {
    
    
    let picker: UIPickerView! = UIPickerView()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    @IBOutlet weak var choosenNei: UITextField!
    var imgView: UIImageView!
    var image: UIImage!

    
    var NeiArr = [Neighborhood]()
    
    var imgArr = [Data]()
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var cityID: Int = 0
    var neighboorhoodID: Int = 0
    var selectedNeighborhood: String?
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNeighborhoodList()
        // Text View UI
        setupTextViewUI()
        
        // Method
        pic(sender: pic_1)
        pic(sender: pic_2)
        pic(sender: pic_3)
        pic(sender: pic_4)
        
        // Set up pickerview
        createPicker()
        
        print("latitude(TICKET): \(self.latitude)")
        print("longitude(TICKET): \(self.longitude)")
        print("Token(ticketViewDidLoad): \(self.token)")
        print("Image Array: \(imgArr)")
    }
    
    
    func setupTextViewUI() {
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
    }
    
    func pic(sender: UIImageView!) {
        switch sender.tag {
            
        case 1:
            setupPic(pic: pic_2, action: #selector(self.imageTap_2))
            
        case 2: setupPic(pic: pic_3, action: #selector(self.imageTap_3))
            
        case 3: setupPic(pic: pic_4, action: #selector(self.imageTap_4))
            
        default:
            setupPic(pic: pic_1, action: #selector(self.imageTap))
        }
    }
    
    func setupPic(pic: UIImageView!, action: Selector){
        pic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        pic.isUserInteractionEnabled = true
    }
    
    @objc func imageTap() {
        print("image clicked")
        self.imgView = pic_1
        showImage()
    }
    
    @objc func imageTap_2() {
        print("image 2 clicked")
        self.imgView = pic_2
        showImage()
    }
    
    @objc func imageTap_3() {
        print("image 3 clicked")
        self.imgView = self.pic_3
        showImage()
    }
    
    @objc func imageTap_4() {
        print("image 4 clicked")
        self.imgView = pic_4
        showImage()
    }
    
    func createPicker() {
        picker.delegate = self
        picker.dataSource = self
        choosenNei.inputView = picker
        choosenNei.inputAccessoryView = createToolBar()
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
    
    
    @IBAction func confirmTicket(_ sender: Any) {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        if self.textView.text == "" {
            self.textView.textColor = UIColor.lightGray //need to change the color
            self.textView.text = "."
        }
        
        let parameters = [
            "description": textView.text!,
            "latitude": latitude,
            "longitude": longitude,
            "city": self.cityID,
            "neighborhood": self.neighboorhoodID
            ] as [String : AnyObject]
        
        if self.imgArr.isEmpty {
            print("Array Count: \(self.imgArr.count)")
            self.showAlert(title: "خطأ", message: "الرجاء ارفاق ١ - ٤ صور")
        }
        
        
        
        switch self.neighboorhoodID {
        case 3377...3437:
            print("passed")
        default:
            print("The neighborhood must be between 3377 and 3437.")
            self.showAlert(title: "خطأ", message: "الرجاء اختيار حي")
        }
        
        if Connectivity.isConnectedToInternet {
            Alamofire.upload(multipartFormData:
                { (multipartFormData ) in
                    
                    for i in 0..<self.imgArr.count {
                        multipartFormData.append(
                            self.imgArr[i] ,
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
                        
                        self.goToTicketList()
                        
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
            
        } // End of Connection check
        else {
            self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
        } // end of else connection
        
    } // End of ConfirmTicket Button
    
    func goToTicketList() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        vc.getTicketsList()
        self.present(vc, animated: true, completion: nil)
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
                
                self.choosenNei.text = responseObject[0].nameAr
                self.neighboorhoodID = responseObject[0].id
                self.cityID = Int(responseObject[0].cityID)!
                
                
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
            
            DispatchQueue.main.async {
                self.picker.reloadComponent(0)
            }
        }
    }
} // End of class



extension ticketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImage() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        // imgPicker.sourceType = .camera
        imgPicker.sourceType = .photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        
        self.imgView.image = self.image
        let imgData = self.imgView.image!.jpegData(compressionQuality: 0.5)!
        imgArr.append(imgData)
        print("Image Array: \(imgArr)")
        
        dismiss(animated: true, completion: nil)
    }
}



extension ticketViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.NeiArr.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NeiArr[row].nameAr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.cityID = Int(NeiArr[row].cityID)!
        print("City ID: \(self.cityID)")
        
        self.neighboorhoodID = NeiArr[row].id
        print("Nei ID: \(self.neighboorhoodID)")
        
        selectedNeighborhood = NeiArr[row].nameAr
        choosenNei.text = selectedNeighborhood
    }
}



