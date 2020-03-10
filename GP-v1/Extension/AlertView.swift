//
//  AlertView.swift
//  GP-v1
//
//  Created by Thekra Faisal on 15/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
  
   
    
    @IBOutlet var ParentView: UIView!
    @IBOutlet weak var alertImg: UIButton!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         Bundle.main.loadNibNamed("Alert_View", owner: self, options: nil)
         commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func commonInit() {
//         img.layer.cornerRadius = 30
//         img.layer.borderColor = UIColor.white.cgColor
//         img.layer.borderWidth = 2
//
//         alertView.layer.cornerRadius = 10

         ParentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
         ParentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
     }
     
     enum AlertType {
         case success
         case failure
     }
     
     func showAlert(message: String, alertType: AlertType) {
         //self.titleLbl.text = title
        self.alertLabel.text = message
       //alertLabel.alpha = 1
         switch alertType {
         case .success:
            alertImg.imageView?.image = UIImage(named: "success")
           // alertImg.alpha = 1
             //doneBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
         case .failure:
             alertImg.imageView?.image = UIImage(named: "failure")
            //alertImg.alpha = 1
             //doneBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
         }
         
         //addSubview(parentView)
     }
    
    @IBAction func alretPressed(_ sender: Any) {
        
//        alertImg.alpha = 0
//        alertLabel.alpha = 0
        ParentView.removeFromSuperview()
    }
    
    
}
