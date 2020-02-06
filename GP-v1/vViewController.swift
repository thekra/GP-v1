//
//  vViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 11/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class vViewController: UIViewController {

   // @IBOutlet weak var lab: UILabel!
   // var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        lab.text = name
    }
    @IBAction func pres(_ sender: UIButton) {
        performSegue(withIdentifier: "test", sender: nil)
    }
    

    

}
