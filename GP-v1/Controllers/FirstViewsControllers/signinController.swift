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
import BonsaiController

class signinController: UIViewController {
    
    @IBOutlet var mainV: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    

    var roleID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            onBoarding.instance.flag = false
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapVieww") as! mapViewController
            self.navigationController?.pushViewController(vc, animated: false)
                                    
                                }
            if UserDefaults.standard.bool(forKey: "isEmpLoggedIn") == true {
                                    let storyboard = UIStoryboard(name: "Employee", bundle: nil)
                                                               let vc = storyboard.instantiateViewController(withIdentifier: "TableViewEmp") as! TicketsListEmpViewController
                                                              self.navigationController?.pushViewController(vc, animated: false)
                
                                }
                    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        mainV.addGestureRecognizer(tap)
        setupUI()
    }
    
    func setupUI() {
        signinButton.clipsToBounds = true
        signinButton.layer.cornerRadius = 20
        childView.roundCorner(corners: [.topRight, .topLeft] , radius: 15)
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
        let vc = self.storyboard?.instantiateViewController(identifier: "signup") as! signupViewController
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func resetPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "resetPassword") as! resetPasswordViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signinButton(_ sender: Any) {
        
        let i = self.startAnActivityIndicator()
           
            API.login(email: emailTextField.text!, password: passwordTextField.text!) { (error: Error?, success: Bool, roleID: String, message: String) in
                if success {
                    i.stopAnimating()
                    
                    if roleID == "1" {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        self.roleID = Int(roleID)!
                        print(self.roleID)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapVieww") as! mapViewController
                        self.present(vc, animated: true, completion: nil)
                    
                    } else if roleID == "4" {
                        UserDefaults.standard.set(true, forKey: "isEmpLoggedIn")
                        self.roleID = Int(roleID)!
                        print(self.roleID)
                        let storyboard = UIStoryboard(name: "Employee", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TableViewEmp") as! TicketsListEmpViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                } else {
                    i.stopAnimating()
                    AlertView.instance.showAlert(message: message, alertType: .failure)
                               self.view.addSubview(AlertView.instance.ParentView)
                }
            }
        
    } // End of signin button
    

    
    // MARK: - Keyboard Functions
    
    func subscribeToKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let textFieldPosition = passwordTextField.frame.origin.y + passwordTextField.frame.size.height
        
        if textFieldPosition > (view.frame.size.height - getKeyboardHeight(notification)){

    if self.view.frame.origin.y == 0 {

          self.view.frame.origin.y -=
            
                getKeyboardHeight(notification)
        
            }
        }
    }
    
    @objc func keyboardWillHide(_ notifcation: Notification) {
        if passwordTextField.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
        
    }
}
/*
 - Storyboard: You're using a large SB -> Split it up -> 1 SB : 1 Controller
    - Folder: LoginController
        - LoginController.storyboardboard
        - LoginController.swift
        - Class: LoginController
 - Naming: Class name starts with Uppercase
 
 */

