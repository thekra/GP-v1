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
//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//           return UserDefaults.standard.object(forKey: key) != nil
//       }
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

extension UILabel {
    func roundCornerr(corners: UIRectCorner, radius: Int = 8) {
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
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
              return UserDefaults.standard.object(forKey: key) != nil
          }
    
    func allowAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "الاعدادات", style: .default) { (_) -> Void in
         guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
               DispatchQueue.main.async {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
               }
             }
        }
        let cancelAction = UIAlertAction(title: "الغاء", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
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
        ai.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ai.frame = CGRect(x: 210, y: 290, width: 5, height: 5)
        
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
    
    func convertEngNumToArabicNumm(num: Int) -> String {
        var f = ""
          let number = NSNumber(value: Int(num))
          let Formatter = NumberFormatter()
          Formatter.locale = Locale(identifier: "ar")
          if let final = Formatter.string(from: number) {
            f = final
              print(final)
          }
          return f
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
    
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "[^05](5|0|3|6|4|9|1|8|7)([0-9]{7})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
}
