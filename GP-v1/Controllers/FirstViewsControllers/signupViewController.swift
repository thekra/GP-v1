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
    
    
    @IBOutlet var signupview: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conPasswordTF: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        signupview.addGestureRecognizer(tap)
        
        setupUI()
    }
    
    func setupUI() {
        signupButton.clipsToBounds = true
        signupButton.layer.cornerRadius = 20
        bottomView.roundCorner(corners: [.topRight, .topLeft] , radius: 15)
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
        
        let i = self.startAnActivityIndicator()
        
                API.register(email: emailTF.text!, password: passwordTF.text!, password_confirmation: conPasswordTF.text!) { (error: Error?, success: Bool, message: String) in
                    if success {
                        i.stopAnimating()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapVieww") as! mapViewController
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        i.stopAnimating()
                        AlertView.instance.showAlert(message: message, alertType: .failure)
                        self.view.addSubview(AlertView.instance.ParentView)
                    }
                }
            } // End of connection

    
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
            self.view.frame.origin.y = 0
            
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
        
    }
    
} // End of class
