//
//  TicketInfoViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class TicketInfoViewController: UIViewController {

    @IBOutlet weak var ticketInfoView: UIView!
    @IBOutlet weak var ticketDesc: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var neighborhood: UILabel!
    
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    
    var ticket: TicketCell?
    var ticketID: Int = 0
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketInfoView.layer.cornerRadius = 30
        ticketDesc.layer.cornerRadius = 30
        neighborhood.layer.cornerRadius = 30
        deleteButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        
        ticketDesc.text = ticket?[0].ticket.ticketDescription
        neighborhood.text = ticket?[0].location[0].neighborhood
//        ticket?[0].location[0].neighborhood.neighborhoods[0].nameAr
//        print("Nei \(String(describing: ticket?[0].location[0].neighborhood.neighborhoods[0].nameAr))")
        
        
    }
    
   
    
}
    


