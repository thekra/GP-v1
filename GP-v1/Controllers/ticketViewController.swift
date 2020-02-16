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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    var imgView: UIImageView!
    var image: UIImage!
    
    var longitude = 0.0
    var latitude = 0.0
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text View UI
        setupTextViewUI()
        
        pic(sender: pic_1)
        pic(sender: pic_2)
        pic(sender: pic_3)
        pic(sender: pic_4)
        
        print("latitude(TICKET): \(self.latitude)")
        print("longitude(TICKET): \(self.longitude)")
        print("Token(ticketViewDidLoad): \(self.token)")
    }
    
    
    func setupTextViewUI() {
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
    }
    
    func pic(sender: UIImageView!) {
        switch sender.tag {
        case 1:
            setupPic(pic: pic_2, action: #selector(self.imageTap_2))
            //    pic_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_2)))
            
        case 2: setupPic(pic: pic_3, action: #selector(self.imageTap_3))
        //    pic_3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_3)))
        case 3: setupPic(pic: pic_4, action: #selector(self.imageTap_4))
            
            //    pic_4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_4)))
            
        default:
            setupPic(pic: pic_1, action: #selector(self.imageTap)) //pic_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        }
        
        //        pic_1.isUserInteractionEnabled = true
        //        pic_2.isUserInteractionEnabled = true
        //        pic_3.isUserInteractionEnabled = true
        //        pic_4.isUserInteractionEnabled = true
        
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
    
    @IBAction func confirmTicket(_ sender: Any) {
        
        let imgData = image.jpegData(compressionQuality: 0.5)
        let urlString = "http://www.ai-rdm.website/api/ticket/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        let parameters = [
            "description": "blahh",
            "photos": imgData!,
            "latitude": latitude,
            "longitude": longitude,
            "city": 6,
            "neighborhood": 3377
            ] as [String : AnyObject]
        
        
        Alamofire.upload(multipartFormData:
            { (multipartFormData ) in
                for (key, value) in parameters {
                    if key == "photos" {
                        multipartFormData.append(
                            value as! Data,
                            withName: key,
                            fileName: "swift_file.jpeg",
                            mimeType: "image/jpeg"
                        )
                    }  else
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    
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
                }
            case .failure(let encodingError):
                // hide progressbas here
                print("ERROR RESPONSE: \(encodingError)")
            }
        })
        
        
        //        if let data = self.image.jpegData(compressionQuality: 1) {
        //          let parameters: Parameters = [
        //            "access_token" : self.token
        //          ]
        //          // You can change your image name here, i use NSURL image and convert into string
        //          let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        //          let fileName = imageURL.absouluteString
        //          // Start Alamofire
        //          Alamofire.upload(multipartFormData: { multipartFormData in
        //          for (key,value) in parameters {
        //               multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
        //          }
        //          multipartFormData.append(data, withName: "avatar", fileName: fileName!,mimeType: "image/jpeg")
        //         },
        //                           usingThreshold: UInt64.init(),
        //         to: "YourURL",
        //         method: .put,
        //         encodingCompletion: { encodingResult in
        //         switch encodingResult {
        //           case .success(let upload, _, _):
        //                 upload.responseJSON { response in
        //                 debugPrint(response)
        //                 }
        //           case .failure(let encodingError):
        //                print(encodingError)
        //           }
        //         })
        //        }
        
        //-------------
        
        //        Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
        //
        //            let count = imageToUpload.count
        //
        //            for i in 0..<count{
        //                multipartFormData.append(imageToUpload[i], withName: "morephoto[\(i)]", fileName: "photo\(i).jpeg" , mimeType: "image/jpeg")
        //
        //            }
        //            for (key, value) in parameterrs {
        //
        //                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
        //            }
        //            print(multipartFormData)
        //        }, to: urlString) { (result) in
        //
        //                switch result {
        //                case .success(let upload, _ , _):
        //
        //                    upload.uploadProgress(closure: { (progress) in
        //
        //                        print("uploding: \(progress.fractionCompleted)")
        //                    })
        //
        //                    upload.responseJSON { response in
        //
        //                    print(response.result.value!)
        //                    let resp = response.result.value! as! NSDictionary
        //                    if resp["status"] as! String == "success"{
        //                        print(response.result.value!)
        //                        let alert = UIAlertController(title: "Alert", message: "Image Upload Successful", preferredStyle: UIAlertController.Style.alert)
        //                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        //                        self.present(alert, animated: true, completion: nil)
        //
        //
        //                    }
        //                    else{
        //
        //                    }
        //
        //
        //                }
        //
        //            case .failure(let encodingError):
        //                print("failed")
        //                print(encodingError)
        //
        //            }
        //        }
        //    }
        
    }
    
}



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
        
        dismiss(animated: true, completion: nil)
    }
}



