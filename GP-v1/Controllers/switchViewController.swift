//
//  switchViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 10/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class switchViewController: UIViewController {

    @IBOutlet weak var ticketsCount: UILabel!
    @IBOutlet weak var hiUser: UILabel!
    var userName = UserDefaults.standard.string(forKey: "name")!
    //var ticket: TicketCell?
    var count = 0
    //self.imagesCount = (ticket?[0].photos.count)!
    var ticket = ticketListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hiUser.text = "مرحباً، \(userName)"
        self.count = self.ticket.ticketsCount
        //self.count = self.ticket!.count
        print("tickets count switch\(self.ticket.ticketsCount)")
        ticketsCount.text = //String(UserDefaults.standard.integer(forKey: "count"))
            String(self.count)
    }
    
    @IBAction func goToMap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! mapViewController
               self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func profile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfileViewController
                      self.present(vc, animated: true, completion: nil)
    }
    @IBAction func ticketListButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
