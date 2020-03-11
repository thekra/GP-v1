//
//  onBoarding.swift
//  GP-v1
//
//  Created by Thekra Faisal on 16/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import UIKit

class onBoarding: UIView {
    
    static let instance = onBoarding()
    
    @IBOutlet var pView: UIView!
    var flag = true
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           Bundle.main.loadNibNamed("onBoarding", owner: self, options: nil)
           commonInit()
          setupView(view: pView, action: #selector(self.viewTapped))
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
      
       
       private func commonInit() {
        
       
            
            pView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            pView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
          
        
       }
       
      func setupView(view: UIView!, action: Selector){
               view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
           }
      
       @objc func viewTapped() {
               pView.removeFromSuperview()
                flag = false
           }
    
}
