//
//  ticketViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire
import BonsaiController

protocol con {
    func confirmPressed()
}

class ticketViewController:  UIViewController, UITextViewDelegate, con {
    
    
    let picker: UIPickerView! = UIPickerView()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    @IBOutlet weak var choosenNei: UITextField!
    var imgView: UIImageView!
    var image: UIImage!
    
    
    @IBOutlet weak var charactersCount: UILabel!
    var NeiArr = [Neighborhood]()
    var temp = Data()
    var imgArr = [Data]()
    
    var count1 = 0
    var count2 = 0
    var count3 = 0
    var count4 = 0
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var cityID: Int = 0
    var neighboorhoodID: Int = 0
    var selectedNeighborhood: String?
    var aNum = ""
    var bNum = ""
    var lastKeyboardHeight: CGFloat = 0.0
    
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstPicUI()
        subscribeToKeyboardNotification()
        aNum = self.convertEngNumToArabicNumm(num: 190)
        bNum = self.convertEngNumToArabicNumm(num: 0)
        charactersCount.text = "\(bNum) / \(aNum)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        subscribeToKeyboardNotification()
        
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var flag = true
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        let str = textView.text + text
        
        let aNum = self.convertEngNumToArabicNumm(num: newLength)
        charactersCount.text =  "\(aNum) / \(self.aNum)"
        if str.utf16.count < 190 {
            flag = true
        } else {
            flag = false
        }
        return flag
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeToKeyboardNotification()
    }
    
    //MARK: - dismiss keyboard function
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Functions
    
    func subscribeToKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textView.isFirstResponder{
            
            print("self.view.frame.origin.y: \(self.view.frame.origin.y)")
            print("keyboard height: \(getKeyboardHeight(notification))")
            
            //lastKeyboardHeight = getKeyboardHeight(notification)
            
            if self.view.frame.origin.y == 231 {
                
                if getKeyboardHeight(notification) == 271 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                else if getKeyboardHeight(notification) == 226 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                
            } else if self.view.frame.origin.y == 391 {
                if getKeyboardHeight(notification) == 346 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                else if getKeyboardHeight(notification) == 301 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                } 
                
            } else if self.view.frame.origin.y == 307 {
                
                if getKeyboardHeight(notification) == 336 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                    
                } else if getKeyboardHeight(notification) == 335 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                    
                else if getKeyboardHeight(notification) == 291 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                
            } else if self.view.frame.origin.y == 162 {
                
                if getKeyboardHeight(notification) == 260 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                    
                    print("eight 162, 260: y: \(self.view.frame.origin.y) , currentKey: \(getKeyboardHeight(notification)), lastKey: \(lastKeyboardHeight)")
                }
                else if getKeyboardHeight(notification) == 216 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                    
                    print("eight 162, 216: y: \(self.view.frame.origin.y) , currentKey: \(getKeyboardHeight(notification)), lastKey: \(lastKeyboardHeight)")
                }
            }
        }
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        let keyboardSize1 = getKeyboardHeight(notification)

        if lastKeyboardHeight != keyboardSize1 {
            if lastKeyboardHeight < keyboardSize1{
                let keyboardDifference: CGFloat = keyboardSize1 - lastKeyboardHeight
                self.view.frame.origin.y -= keyboardDifference

            } else {
                let keyboardDifference: CGFloat = lastKeyboardHeight - keyboardSize1
                self.view.frame.origin.y += keyboardDifference
            }
            lastKeyboardHeight = keyboardSize1
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if textView.isFirstResponder {
            let plus = 231 - lastKeyboardHeight
            let eleven = 391 - lastKeyboardHeight
            let eight = 162 - lastKeyboardHeight
            let elevenPro = 307 - lastKeyboardHeight
            
            if self.view.frame.origin.y == plus {
                
                if lastKeyboardHeight == 271 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    
                } else if lastKeyboardHeight == 226 {
                    self.view.frame.origin.y += lastKeyboardHeight
                }
                
            } else if self.view.frame.origin.y == eleven {
                if lastKeyboardHeight == 346 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    
                } else if lastKeyboardHeight == 301 {
                    self.view.frame.origin.y += lastKeyboardHeight
                }
                
            } else if self.view.frame.origin.y == elevenPro {
                if lastKeyboardHeight == 336 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    
                } else if lastKeyboardHeight == 335 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    
                } else if lastKeyboardHeight == 291 {
                    self.view.frame.origin.y += lastKeyboardHeight
                }
                
            } else if self.view.frame.origin.y == eight {
                
                if lastKeyboardHeight == 260 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    print("eight 260: y: \(self.view.frame.origin.y) , currentKey: \(getKeyboardHeight(notification)), lastKey: \(lastKeyboardHeight)")
                    
                } else if lastKeyboardHeight == 216 {
                    self.view.frame.origin.y += lastKeyboardHeight
                    print("eight 216: y: \(self.view.frame.origin.y) , currentKey: \(getKeyboardHeight(notification)), lastKey: \(lastKeyboardHeight)")
                }
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
        
    }
    
    func setupTextViewUI() {
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
    }
    
    
    func firstPicUI() {
        pic_1.isUserInteractionEnabled = true
        
        pic_2.isUserInteractionEnabled = false
        pic_2.image = UIImage(named: "Rectangle 3")
        
        pic_3.isUserInteractionEnabled = false
        pic_3.image = UIImage(named: "Rectangle 3")
        
        pic_4.isUserInteractionEnabled = false
        pic_4.image = UIImage(named: "Rectangle 3")
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
    }
    
    func enablePic(pic: UIImageView) {
        
        pic.isUserInteractionEnabled = true
        pic.image = UIImage(named: "Repeat Grid 1 copy")
        
    }
    
    @objc func imageTap() {
        print("image clicked")
        
        self.imgView = pic_1
        showImage()
        enablePic(pic: pic_2)
    }
    
    @objc func imageTap_2() {
        print("image 2 clicked")
        
        self.imgView = pic_2
        showImage()
        enablePic(pic: pic_3)
    }
    
    @objc func imageTap_3() {
        print("image 3 clicked")
        
        self.imgView = self.pic_3
        showImage()
        enablePic(pic: pic_4)
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
    
    
    func confirmPressed()  {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        if self.textView.text == "" {
            self.textView.textColor = UIColor.lightGray // Need to change the color
            self.textView.text = "."
        }
        
        let parameters = [
            "description": textView.text!,
            "latitude": latitude,
            "longitude": longitude,
            "city": self.cityID,
            "neighborhood": self.neighboorhoodID
            ] as [String : AnyObject]
        
        let i = self.startAnActivityIndicator1()
        
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
                        
                        
                        if response.response?.statusCode == 200 {
                            i.stopAnimating()
                            //self.goToTicketList()
                        }
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
            //self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
            i.stopAnimating()
            AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
            AlertView.instance.ParentView.frame = CGRect(x: 0, y: 200 - self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(AlertView.instance.ParentView)
        } // end of else connection
        //return code
    }
    
    @IBAction func confirmTicket(_ sender: Any) {
        print("self.view.frame.origin.y: \(self.view.frame.origin.y)")
        let i = self.startAnActivityIndicator1()
        
        if self.imgArr.isEmpty {
            print("Array Count: \(self.imgArr.count)")
            i.stopAnimating()
            //self.showAlert(title: "خطأ", message: "الرجاء ارفاق ١ - ٤ صور")
            
            AlertView.instance.showAlert(message: "الرجاء ارفاق ١ - ٤ صور", alertType: .failure)
            AlertView.instance.ParentView.frame = CGRect(x: 0, y: -221, width: 414, height: 896) // not AutoLayout
            self.view.addSubview(AlertView.instance.ParentView)
        } else {
            
            if Connectivity.isConnectedToInternet {
                i.stopAnimating()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirm") as! confirmTicketMessageViewController
                vc.delegate?.confirmPressed()
                vc.transitioningDelegate = self
                vc.modalPresentationStyle = .custom
                vc.delegate = self
                
                self.present(vc, animated: true, completion: nil)
            } else {
                i.stopAnimating()
                AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
                AlertView.instance.ParentView.frame = CGRect(x: 0, y: -200, width: 414, height: 896)
                self.view.addSubview(AlertView.instance.ParentView)
            }
        }
    } // End of ConfirmTicket Button
    
    func goToTicketList() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        //vc.getTicketsList()
        self.present(vc, animated: true, completion: nil)
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
    }
} // End of class



extension ticketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImage() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        // imgPicker.sourceType = .camera
        imgPicker.sourceType = .photoLibrary
        imgPicker.modalPresentationStyle = .overFullScreen
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if self.imgView.tag == 0 {
            pic_2.isUserInteractionEnabled = false
            pic_2.image = UIImage(named: "Rectangle 3")
            dismiss(animated: true, completion: nil)
        }
        
        if self.imgView.tag == 1 {
            pic_3.isUserInteractionEnabled = false
            pic_3.image = UIImage(named: "Rectangle 3")
            dismiss(animated: true, completion: nil)
        }
        
        if self.imgView.tag == 2 {
            pic_4.isUserInteractionEnabled = false
            pic_4.image = UIImage(named: "Rectangle 3")
            dismiss(animated: true, completion: nil)
        }
        
        if self.imgView.tag == 3 {
            pic_4.isUserInteractionEnabled = false
            pic_4.image = UIImage(named: "Rectangle 3")
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        
        self.imgView.image = self.image
        let imgData = self.imgView.image!.jpegData(compressionQuality: 0.5)!
        print("img tag \(self.imgView.tag)")
        
        if self.imgView.tag == 0 {
            
            if count1 == 0 {
                self.temp = imgData
                imgArr.append(imgData)
                count1 += 1
            } else if count1 == 1 {
                let i = imgArr.firstIndex(of: temp)!
                imgArr.remove(at: i)
                imgArr.append(imgData)
                count1 -= 1
            }
            print("c1 \(count1)")
        }
        
        if self.imgView.tag == 1 {
            
            if count2 == 0 {
                self.temp = imgData
                imgArr.append(imgData)
                count2 += 1
            } else if count2 == 1 {
                let i = imgArr.firstIndex(of: temp)!
                imgArr.remove(at: i)
                imgArr.append(imgData)
                count2 -= 1
            }
            print("c2 \(count2)")
        }
        
        if self.imgView.tag == 2 {
            if count3 == 0 {
                self.temp = imgData
                imgArr.append(imgData)
                count3 += 1
            } else if count3 == 1 {
                let i = imgArr.firstIndex(of: temp)!
                imgArr.remove(at: i)
                imgArr.append(imgData)
                count3 -= 1
            }
            print("c3 \(count3)")
        }
        
        if self.imgView.tag == 3 {
            if count4 == 0 {
                self.temp = imgData
                imgArr.append(imgData)
                count4 += 1
            } else if count4 == 1 {
                let i = imgArr.firstIndex(of: temp)!
                imgArr.remove(at: i)
                imgArr.append(imgData)
                count4 -= 1
            }
            print("c4 \(count4)")
        }
        
        
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

//extension ticketViewController : UIPresentationController {
//    override var frameOfPresentedViewInContainerView: CGRect {
//        get {
//            guard let theView = containerView else {
//                return CGRect.zero
//            }
//
//            return CGRect(x: 0, y: theView.bounds.height/2, width: theView.bounds.width, height: theView.bounds.height/2)
//        }
//    }
//}

//
extension ticketViewController: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        print(containerViewFrame.height)
        print(containerViewFrame.height / (4/3))
        
        //        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 3), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height - 505), size: CGSize(width: containerViewFrame.width, height: 505))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, presentedViewController: presented, delegate: self)
        
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
    //
    //
    //
}

