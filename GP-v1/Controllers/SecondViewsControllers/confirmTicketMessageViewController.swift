//
//  confirmTicketMessageViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 02/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class confirmTicketMessageViewController: UIViewController {
    
    static let instance = confirmTicketMessageViewController()
    var delegate: con?
    var code = 0

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
    }
   
    
    @IBAction func yesPressed(_ sender: Any) {
        self.delegate?.confirmPressed()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
