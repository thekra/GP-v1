//
//  signupViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 10/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class signupViewController: UIViewController {
var token = UserDefaults.standard.string(forKey: "access_token") ?? ""
    var namee = UserDefaults.standard.string(forKey: "name") ?? ""
    
    @IBOutlet var signupview: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conPasswordTF: UITextField!
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        signupview.addGestureRecognizer(tap)
    }
    //MARK: - dismiss keyboard function
    @objc func dismissKeyboard() {
      signupview.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeToKeyboardNotification()
    }
    
    
    
    
    @IBAction func signupButton(_ sender: Any) {
        let urlString = "http://www.ai-rdm.website/api/auth/register"
                
        let body = Signup(email: emailTF.text!, password: passwordTF.text!, password_confirmation: conPasswordTF.text!)
                
                let url = URL(string: urlString)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = try! JSONEncoder().encode(body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                Alamofire.request(request).responseJSON { response in
                 print(response)
                    guard let data = response.data else {

                        
                        DispatchQueue.main.async {
                            print(response.error!)
                           
                        }
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let responseObject =  try decoder.decode(SignupResponse.self, from: data)
                        self.token = responseObject.accessToken
                        //DispatchQueue.main.async {
                        print(responseObject)
                        
                       // self.token = responseObject.accessToken
                        //self.namee = responseObject.success.user_data.name
                        //UserDefaults.standard.set(responseObject.accessToken, forKey: "access_token")
                        //UserDefaults.standard.set(responseObject.user_data.email, forKey: "email")
                        //UserDefaults.standard.set(responseObject.user_data.name, forKey: "name")
                        
                        
                            self.performSegue(withIdentifier: "signedup", sender: nil)
                       // }
                    } catch let parsingError {
                        print("Error:(signup)", parsingError)
                        //self.showAlert(title: "error", message: parsingError as! String)
                    }
                    
                }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let v = segue.destination as! mapViewController
        v.token = self.token
       // v.name = self.namee
        
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
            if conPasswordTF.isFirstResponder{
            self.view.frame.origin.y =
                getKeyboardHeight(notification) * -1
            }
        }

        @objc func keyboardWillHide(_ notifcation: Notification) {
            if conPasswordTF.isFirstResponder {
                self.view.frame.origin.y = 0}
            }
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            return keyboardFrame.cgRectValue.height
            
        }
    }
