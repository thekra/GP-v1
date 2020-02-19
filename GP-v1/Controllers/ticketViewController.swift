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
    var imgView: UIImageView!
    var image: UIImage!
    @IBOutlet weak var choosenNei: UITextField!
    
    
    var cityArr = [City]()
    var NeiArr = [Neighborhood]()
    //var neighborhoodArr : [[String:AnyObject]] = []
    
    var imgArr = [Data]()
    
    
    var cityID: Int = 0
    var neighboorhoodID: Int = 0
    var selectedNeighborhood: String?
    var longitude = 0.0
    var latitude = 0.0
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNeighborhoodList()
        // Text View UI
        setupTextViewUI()
        
        
        pic(sender: pic_1)
        pic(sender: pic_2)
        pic(sender: pic_3)
        pic(sender: pic_4)
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
    }

    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))

        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
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
        
        
        let parameters = [
            "description": textView.text!,
            "latitude": latitude,
            "longitude": longitude,
            "city": self.cityID,
            "neighborhood": self.neighboorhoodID
            ] as [String : AnyObject]
        
        
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
                    print(parameters)
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
                    print("REsponde Data: \(response.data)")
                    print("REsponse Result: \(response.result)")
                    print("REsponse REquest: \(response.request))")
                    print("REsponse Description: \(response.description))")
                    print("REsponse DEbug Desc: \(response.debugDescription))")
                    print("REsponse Metrices: \(response.metrics))")
                    
                   guard let data = response.data else {

                       DispatchQueue.main.async {
                           print(response.error!)
                       }
                       return
                   }
                    let decoder = JSONDecoder()
                              do {
                                let responseObject =  try decoder.decode(Ticket.self, from: data)
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
        
        dismiss(animated: true, completion: nil)
        
    } // End of ConfirmTicket Button
    

    func getNeighborhoodList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/neighborhoods"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            let result = response.result.value as? [[String : AnyObject]]
            print(result!)
            
            print(response.response)
            
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
        // if != nil
        dismiss(animated: true, completion: nil)
    }
}



extension ticketViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NeiArr.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.cityID = Int(NeiArr[row].cityID)!
        self.neighboorhoodID = NeiArr[row].id
        return NeiArr[row].nameAr
    }
//
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNeighborhood = NeiArr[row].nameAr
        choosenNei.text = selectedNeighborhood
    }
}



