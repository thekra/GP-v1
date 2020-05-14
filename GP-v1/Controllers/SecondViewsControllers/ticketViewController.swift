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
import AVFoundation

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
    
    @objc func dismissKeyboardPicker() {
        view.endEditing(true)
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
                
            } else if lastKeyboardHeight == 216 {
                self.view.frame.origin.y += lastKeyboardHeight
            }
        }
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
        if textView.isFirstResponder {
            
            print("self.view.frame.origin.y: \(self.view.frame.origin.y)")
            print("keyboard height: \(getKeyboardHeight(notification))")
            
            //lastKeyboardHeight = getKeyboardHeight(notification)
            //picker.frame.origin.y = getKeyboardHeight(notification)
            
            // 8 plus
            if self.view.frame.origin.y == 231 {
                print("picker.frame.origin.y: \(picker.frame.origin.y)")
                if getKeyboardHeight(notification) == 271 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                else if getKeyboardHeight(notification) == 226 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                
                
                // 11
            } else if self.view.frame.origin.y == 391 {
                if getKeyboardHeight(notification) == 346 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                else if getKeyboardHeight(notification) == 301 {
                    self.view.frame.origin.y -=
                        getKeyboardHeight(notification)
                }
                
                // 11 Pro
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
                
                // 8
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
        if textView.isFirstResponder {
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
                print("picker.frame.origin.y: \(picker.frame.origin.y)")
                if picker.frame.origin.y == 44 {
                    self.view.frame.origin.y += lastKeyboardHeight
                } else
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
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
                guard accessGranted == true else { return }
                DispatchQueue.main.async {
                    self.imgView = self.pic_1
                    self.showImage()
                    self.enablePic(pic: self.pic_2)
                }
            })
        case .authorized:
            self.imgView = pic_1
            showImage()
            enablePic(pic: pic_2)
        case .restricted, .denied:
            self.allowAlert(title: "الكاميرا غير مفعلة", message: "الرجاء الذهاب الى الاعدادات وتفعيلها")
        }
        
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboardPicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    
    func confirmPressed()  {
        
        let i = self.startAnActivityIndicator1()
        if Connectivity.isConnectedToInternet {
            API.newTicket(decription: textView, latitude: self.latitude, longitude: self.longitude, cityID: self.cityID, neighborhoodID: self.neighboorhoodID, imgArr: self.imgArr) { (error: Error?, success: Bool, message: String) in
                if success {
                    i.stopAnimating()
                    self.goToTicketList()
                }
            }
        } // End of Connection check
        else {
            errorView(message: "لا يوجد اتصال بالانترنت")
            
        } // end of else connection
    }
    
    func goToTicketList() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func errorView(message: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Error") as! ErrorViewController
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.message = message
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func confirmView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirm") as! confirmTicketMessageViewController
        vc.delegate?.confirmPressed()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func confirmTicket(_ sender: Any) {
        
        let i = self.startAnActivityIndicator1()
        
        if self.imgArr.isEmpty {
            print("Array Count: \(self.imgArr.count)")
            errorView(message: "الرجاء ارفاق ١ - ٤ صور")
            
        } else {
            
            if Connectivity.isConnectedToInternet {
                i.stopAnimating()
                confirmView()
            } else {
                i.stopAnimating()
                errorView(message: "لا يوجد اتصال بالانترنت")
            }
        }
    } // End of ConfirmTicket Button
    
    
    
    func getNeighborhoodList() {
        
        let urlString = URLs.neighborhood
        
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPicker.sourceType = .camera
        } else {
            self.showAlert(title: "مشكلة في الكاميرا", message: "يبدو انه ليس هنالك وجود لكاميرا الهاتف")
        }
        //imgPicker.sourceType = .photoLibrary
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


extension ticketViewController: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        print(containerViewFrame.height)
        print(containerViewFrame.height / (4/3))
        
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height - 505), size: CGSize(width: containerViewFrame.width, height: 505))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, presentedViewController: presented, delegate: self)
        
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}
