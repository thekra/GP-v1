//
//  resetPasswordViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 12/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class resetPasswordViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emailT: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.roundCorner(corners: [.topRight, .topLeft] , radius: 15)
        resetButton.layer.cornerRadius = 20
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        
        let i = self.startAnActivityIndicator()
        API.reset(email: emailT.text!) { (error: Error?, success: Bool, message: String) in
            if success {
                i.stopAnimating()
                AlertView.instance.showAlert(message: message, alertType: .success)
                self.view.addSubview(AlertView.instance.ParentView)
            } else {
                i.stopAnimating()
                AlertView.instance.showAlert(message: message, alertType: .failure)
                self.view.addSubview(AlertView.instance.ParentView)
            }
        }
    } // End of reset
    
} // End of class
