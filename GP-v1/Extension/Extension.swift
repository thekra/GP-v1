//
//  Extension.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit


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
           ai.center = self.view.center
           ai.hidesWhenStopped = true
           ai.startAnimating()
           return ai
       }
//        
//    func swiftEntry(title: String, message: String) {
//        let customView = UIView()
//        var attributes = EKAttributes(windowLevel: <#<<error type>>#>)
//        attributes.name = title
//    }
    
}



//extension UIViewController {
//    func startAnActivityIndicator() -> UIActivityIndicatorView {
//        let ai = UIActivityIndicatorView(style: .gray)
//        self.view.addSubview(ai)
//        self.view.bringSubviewToFront(ai)
//        ai.center = self.view.center
//        ai.hidesWhenStopped = true
//        ai.startAnimating()
//        return ai
//    }
//}

//extension UIViewController {
////MARK: - dismiss keyboard function
//    @objc func dismissKeyboard(view: UIView) {
//     view.endEditing(true)
//   }
//}
//public struct EKAttributes {
//
//    // Identification
//    public var name: String?
//
//    // Display
//    public var windowLevel: WindowLevel
//    public var position: Position
//    public var precedence: Precedence
//    public var displayDuration: DisplayDuration
//    public var positionConstraints: PositionConstraints
//
//    // User Interaction
//    public var screenInteraction: UserInteraction
//    public var entryInteraction: UserInteraction
//    public var scroll: Scroll
//    public var hapticFeedbackType: NotificationHapticFeedback
//    public var lifecycleEvents: LifecycleEvents
//
//    // Theme & Style
//    public var displayMode = DisplayMode.inferred
//    public var entryBackground: BackgroundStyle
//    public var screenBackground: BackgroundStyle
//    public var shadow: Shadow
//    public var roundCorners: RoundCorners
//    public var border: Border
//    public var statusBar: StatusBar
//
//    // Animations
//    public var entranceAnimation: Animation
//    public var exitAnimation: Animation
//    public var popBehavior: PopBehavior
//}
