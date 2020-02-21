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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: - Signup Button
    @IBAction func signupButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: nil)
    }
    
    
    @IBAction func signinButton(_ sender: Any) {
        
        let urlString = "http://www.ai-rdm.website/api/auth/login"
        
        
        let body = Signin(email: emailTextField.text!, password: passwordTextField.text!)
       
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
     if Connectivity.isConnectedToInternet {
        Alamofire.request(request).validate(statusCode: 200..<300).responseJSON { response in
      print(response)
            
            switch response.result {
            case .success:
                print("Validation Successful")
                print(response.result.description)

                guard let data = response.data else {

                    
                    DispatchQueue.main.async {
                        print(response.error!)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let responseObject =  try decoder.decode(SigninResponse.self, from: data)
                    
                      let tokenn = responseObject.accessToken
                    
                    print("Token: \(tokenn)")
                    UserDefaults.standard.set(tokenn, forKey: "access_token")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! mapViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }  catch let parsingError {
                        print("Error", parsingError)
                }
                
            case let .failure(error):
                   
                 if response.response?.statusCode == 401 {
                               self.showAlert(title: "Error", message: "Email/password are not correct")
                    
                           } else if response.response?.statusCode == 422 {
                               self.showAlert(title: "Error", message: "Invalid input/Missing Input")
                           } else if response.response?.statusCode == 500 {
                               self.showAlert(title: "Error", message: "Server Error")
                    
                           }
                    print(error)
                }
         
        } // End of Alamofire
     
     } // End of connection
     else {
        self.showAlert(title: "Error", message: "No Interent Connection")
        } // end of else connection
} // End of signin button
    
    
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
