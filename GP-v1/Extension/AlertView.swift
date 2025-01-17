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
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("Alert_View", owner: self, options: nil)
        commonInit()
        setupView(view: ParentView, action: #selector(self.viewTapped))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        okButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        
        ParentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        ParentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    func setupView(view: UIView!, action: Selector){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }
    
    @objc func viewTapped() {
        ParentView.removeFromSuperview()
    }
    
    enum AlertType {
        case success
        case failure
        case confirm
    }
    
    func showAlert(message: String, alertType: AlertType) {
        
        self.alertLabel.text = message
        self.alertLabel.textColor = UIColor.white
        
        switch alertType {
        case .success:
            alertImg.image = UIImage(named: "success")
            okButton.setTitleColor(#colorLiteral(red: 0.5098039216, green: 0.7647058824, blue: 0.3803921569, alpha: 1), for: .normal)
            buttonsView.isHidden = true
            okButton.isHidden = false
            
        case .failure:
            alertImg.image = UIImage(named: "failure")
            okButton.setTitleColor(#colorLiteral(red: 0.9411764706, green: 0.2549019608, blue: 0.2549019608, alpha: 1), for: .normal)
            buttonsView.isHidden = true
            okButton.isHidden = false
            
        case .confirm :
            self.alertLabel.textColor = UIColor.black
            alertImg.image = UIImage(named: "sure")
            okButton.isHidden = true
            buttonsView.isHidden = false
            
        }
    }
    
    @IBAction func okPressed(_ sender: Any) {
        ParentView.removeFromSuperview()
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        ParentView.removeFromSuperview()
    }
}
