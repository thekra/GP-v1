//
//  signinController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 07/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class signinController: UIViewController {
        
    @IBOutlet var mainV: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var token = "" //UserDefaults.standard.string(forKey: "access_token") ?? ""
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TOKEN: \(self.token)")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        mainV.addGestureRecognizer(tap)

    }
    

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeToKeyboardNotification()
    }

    //MARK: - dismiss keyboard function
    @objc func dismissKeyboard() {
      mainV.endEditing(true)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "siginup", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier :"signup") as! signupViewController
        //self.present(viewController, animated: true)
        self.performSegue(withIdentifier: "signup", sender: nil)
    }
    /*static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.SESSION) else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                 if statusCode < 400 {
                   
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        
                        self.sessionId = sessionDict["id"] as? String
                        self.userInfo.key = accountDict["key"] as? String
                        
                        self.getUserInfo(completion: { err in
                            
                        })
                    } else {
                        errString = "Couldn't parse response"
                    }
                } else {
                    errString = "Provided login credintials didn't match our records"
                }
            } else {
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }*/
    
    @IBAction func signinButton(_ sender: Any) {
        
        let urlString = "http://www.ai-rdm.website/api/auth/login"
        
        let body = Signin(email: emailTextField.text!, password: passwordTextField.text!)
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(request).validate(statusCode: 200..<300).responseJSON { response in
      print(response)
           
            switch response.result {
            case .success:
                print("Validation Successful")
                print(response.result.description)
                case let .failure(error):
                    print(error)
                }
//                 guard let data = response.data else {
//                     DispatchQueue.main.async {
//                         print(response.error!)
//                     }
//                     return
//                 }
            //  guard case let .failure(error) = response.result else { return }
//
//            let status = response.response?.statusCode
//            print(status)
//            if status == 400 {
//                //self.showAlert(title: "Missing", message: "Please provide us your email/password")
//                print("info")
//            }
//             if let error = error as? AFError {
//
//                 switch error {
//                 case .invalidURL(let url):
//                     print("Invalid URL: \(url) - \(error.localizedDescription)")
//                 case .parameterEncodingFailed(let reason):
//                     print("Parameter encoding failed: \(error.localizedDescription)")
//                     print("Failure Reason: \(reason)")
//                 case .multipartEncodingFailed(let reason):
//                     print("Multipart encoding failed: \(error.localizedDescription)")
//                     print("Failure Reason: \(reason)")
//                 case .responseValidationFailed(let reason):
//                     print("Response validation failed: \(error.localizedDescription)")
//                     print("Failure Reason: \(reason)")
//
//                     switch reason {
//                     case .dataFileNil, .dataFileReadFailed:
//                         print("Downloaded file could not be read")
//                     case .missingContentType(let acceptableContentTypes):
//                         print("Content Type Missing: \(acceptableContentTypes)")
//                     case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
//                         print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
//                     case .unacceptableStatusCode(let code):
//                         print("Response status code was unacceptable: \(code)")
//                     }
//                 case .responseSerializationFailed(let reason):
//                     print("Response serialization failed: \(error.localizedDescription)")
//                     print("Failure Reason: \(reason)")
//                 }
//
//                 print("Underlying error: \(error.underlyingError)")
//             } else if let error = error as? URLError {
//                 print("URLError occurred: \(error)")
//             } else {
//                 print("Unknown error: \(error)")
//             }
         
            guard let data = response.data else {

                
                DispatchQueue.main.async {
                    print(response.error!)
                   
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject =  try decoder.decode(SigninResponse.self, from: data)
                
                //DispatchQueue.main.async {
//                    print("Body: \(responseObject)")
               
                    
                  let tokenn = responseObject.accessToken
                
                print("Token: \(tokenn)")
                UserDefaults.standard.set(tokenn, forKey: "access_token")
                    
                    self.performSegue(withIdentifier: "Login", sender: nil)
              //  }
                
            }  catch let parsingError {
                    print("Error", parsingError)
                //let status = response.response?.statusCode
                
//                print(response.error!)
                //if status == 400 {
                   // self.showAlert(title: "Missing", message: "Please provide us your email/password")
                //}
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login" {
        let vc = segue.destination as! mapViewController
            //vc.token = self.token
            print("Token(signinSegue): \(self.token)")
            //vc.testt = self.token
            
        }
        else if segue.identifier == "signup"{
           segue.destination as! signupViewController
        }
    }
    
    
    // MARK: - Keyboard Functions
    
    // فيه احهزة ماتحتاح ان الكيبورد ينرفع سو احتاج احدد حجم الشاشة اللي يصيرلها كذا
    func subscribeToKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if passwordTextField.isFirstResponder{
        self.view.frame.origin.y =
            getKeyboardHeight(notification) * -1
        }
    }

    @objc func keyboardWillHide(_ notifcation: Notification) {
        if passwordTextField.isFirstResponder {
            self.view.frame.origin.y = 0}
        }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
        
    }
}
