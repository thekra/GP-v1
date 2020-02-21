//
//  TicketInfoViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class TicketInfoViewController: UIViewController {

    @IBOutlet weak var ticketInfoView: UIView!
    @IBOutlet weak var ticketDesc: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketInfoView.layer.cornerRadius = 30
        ticketDesc.layer.cornerRadius = 30
        deleteButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        
    }
    

}
