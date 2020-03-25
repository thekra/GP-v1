//
//  closeTicketViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 01/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class closeTicketViewController: UIViewController {

        @IBOutlet weak var pic_1: UIImageView!
        @IBOutlet weak var pic_2: UIImageView!
        @IBOutlet weak var pic_3: UIImageView!
        @IBOutlet weak var pic_4: UIImageView!
        var imgView: UIImageView!
        var image: UIImage!

        
    @IBOutlet weak var low: UIButton!
    @IBOutlet weak var moderate: UIButton!
    @IBOutlet weak var severe: UIButton!
    
    @IBOutlet weak var closeTicket: UIButton!
    var NeiArr = [Neighborhood]()
        var temp = Data()
        var imgArr = [Data]()
        
        var count1 = 0
        var count2 = 0
        var count3 = 0
        var count4 = 0
        var degree_id = 0
        var ticket_id = 0
    
        var token: String = UserDefaults.standard.string(forKey: "access_token")!
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            firstPicUI()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            buttonUI()
            // Method
            pic(sender: pic_1)
            pic(sender: pic_2)
            pic(sender: pic_3)
            pic(sender: pic_4)
            
            print("Token(ticketViewDidLoad): \(self.token)")
            print("Image Array: \(imgArr)")
        }
    
    func buttonUI () {
        low.layer.cornerRadius = 15
        moderate.layer.cornerRadius = 15
        severe.layer.cornerRadius = 15
        closeTicket.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
    }
    
    @IBAction func lowPressed(_ sender: Any) {
        isSelected(button: low, button2: moderate, button3: severe)
        degree_id = 3
        print(degree_id)
    }
    
    @IBAction func moderatePressed(_ sender: Any) {
        isSelected(button: moderate, button2: low, button3: severe)
                   degree_id = 2
        print(degree_id)

    }
    
    @IBAction func severePressed(_ sender: Any) {
        isSelected(button: severe, button2: moderate, button3: low)
        degree_id = 1
        print(degree_id)
    }
    
    func isSelected(button: UIButton, button2: UIButton, button3: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.4047860503, green: 0.608440578, blue: 0.6136831641, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1), for: .normal)
        button2.backgroundColor = #colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1)
        button2.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button3.backgroundColor = #colorLiteral(red: 0.9489166141, green: 0.9490789771, blue: 0.9489063621, alpha: 1)
        button3.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
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
        
        
        
        @IBAction func closeTicket(_ sender: Any) {
            
            let urlString = "http://www.ai-rdm.website/api/ticket/update"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(self.token)",
                "Content-Type": "multipart/form-data",
                "Accept": "application/json"
            ]
            
            
            let parameters = [
               "ticket_id": self.ticket_id,
                "status" : "SOLVED",
                "degree_id" : self.degree_id
                ] as [String : AnyObject]
            let i = self.startAnActivityIndicator1()
            
            if degree_id == 0 {
                i.stopAnimating()
                               
                AlertView.instance.showAlert(message: "الرجاء اختيار حجم الضرر", alertType: .failure)
                           self.view.addSubview(AlertView.instance.ParentView)
            }
            
            if self.imgArr.isEmpty {
                print("Array Count: \(self.imgArr.count)")
                i.stopAnimating()
                
                AlertView.instance.showAlert(message: "الرجاء ارفاق ١ - ٤ صور", alertType: .failure)
            self.view.addSubview(AlertView.instance.ParentView)
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
                            self.goToTicketList()
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
                self.view.addSubview(AlertView.instance.ParentView)
            } // end of else connection
            
        } // End of ConfirmTicket Button
        
        func goToTicketList() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableViewEmp") as! TicketsListEmpViewController
            self.present(vc, animated: true, completion: nil)
        }
    } // End of class



    extension closeTicketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

