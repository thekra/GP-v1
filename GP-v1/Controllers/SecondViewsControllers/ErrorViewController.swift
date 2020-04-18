//
//  ErrorViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 25/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    
    static let instance = ErrorViewController()
    //var delegate: con?
    
    @IBOutlet weak var errorMessage: UILabel!
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMess()
    }
    
    func errorMess() {
        errorMessage.text = message
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
