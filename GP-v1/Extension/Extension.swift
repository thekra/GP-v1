//
//  Extension.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import UIKit


extension UserDefaults {
    static func contains(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIView {
    func roundCorner(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showAnAlert() {
        let alert = UIAlertController(title: "نجاح", message: "تم تحديث بياناتك!", preferredStyle: .alert)
        let action = UIAlertAction(title: "حسناً", style: .default) { (action) -> Void in
            
            let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "userProfilee") as! userProfileViewController
            
            self.present(viewControllerYouWantToPresent, animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
           let ai = UIActivityIndicatorView(style: .gray)
           self.view.addSubview(ai)
           self.view.bringSubviewToFront(ai)
           ai.transform = CGAffineTransform(scaleX: 2, y: 2)
           ai.center = self.view.center
           ai.hidesWhenStopped = true
           ai.startAnimating()
           return ai
       }
    func startAnActivityIndicator1() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.transform = CGAffineTransform(scaleX: 2, y: 2)
        //ai.frame = CGRect(x: UIScreen.main.bounds.maxX, y: UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        ai.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ai.frame = CGRect(x: 210, y: 290, width: 5, height: 5)
        //ai.frame = CGRect(x: self.view.bounds/CGFloat(3), y: 290, width: 5, height: 5)
        //ai.topAnchor =
       // ai.topAnchor.anchorWithOffset(to: )
//        let top = ai.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50)
//        top.isActive = true
//        let left = ai.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50)
//        left.isActive = true
        
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
    
    func convertEngNumToArabicNum(num: Int, textF: UILabel) {
        
        let number = NSNumber(value: Int(num))
        let Formatter = NumberFormatter()
        Formatter.locale = Locale(identifier: "ar")
        if let final = Formatter.string(from: number) {
            print(final)
            textF.text =  final
        }
        
    }
    
    func convertDateFormater(_ date: String, textF: UILabel)
           {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let date = dateFormatter.date(from: date)
               //dateFormatter.dateFormat = "yyyy-M-d"
            dateFormatter.dateFormat = "d-M-yyyy"
               dateFormatter.locale = Locale(identifier: "ar")
               textF.text = dateFormatter.string(from: date!)
           }
}
