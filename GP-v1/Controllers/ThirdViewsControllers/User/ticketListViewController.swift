//
//  ticketListViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class ticketListViewController: UIViewController {
    static let instance = ticketListViewController()
    
    @IBOutlet weak var ViewT: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelView: UIView!
    
    
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    var ticket: TicketCell?
    var ticketCell = TicketCell()
    var ticketID = 0
    var refreshControl: UIRefreshControl?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTicketsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getTicketsList()
        ViewT.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        labelView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        labelView.isHidden = true
        addRefresh()
    }
    
    func addRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshlist), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshlist() {
        refreshControl?.endRefreshing()
        getTicketsList()
    }
    
    @objc func getTicketsList() {
        let i = self.startAnActivityIndicator()
        
        API.listTickets(tableView: self.tableView) { (error: Error?, success: Bool, ticketCell: TicketCell, message: String) in
            if success {
                i.stopAnimating()
                self.ticketCell = ticketCell
                if self.ticketCell.isEmpty {
                    i.stopAnimating()
                    self.labelView.isHidden = false
                }
        } else {
            i.stopAnimating()
            AlertView.instance.showAlert(message: message, alertType: .failure)
                       self.view.addSubview(AlertView.instance.ParentView)
        } // end of else connection
        
    } // end of function
    
} // end of class
}
extension ticketListViewController:  UITableViewDelegate, UITableViewDataSource {
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ticketCell.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.ticketID = ticketCell[indexPath.row].ticket.id
        print("TicketID: \(ticketID)")
        print("You tapped cell number \(indexPath.row).")
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let des = segue.destination as? TicketInfoViewController {
            des.ticket = [ticketCell[(tableView.indexPathForSelectedRow?.row)!]]
            //des.ticket_id = ticketCell[indexPath.row].ticket.id
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ticketListTableViewCell
        cell.statusLabel.text = self.ticketCell[indexPath.row].ticket.statusAr
        let status = self.ticketCell[indexPath.row].ticket.status
        
        if status == "OPEN" {
            cell.cellImg.image = UIImage(named: "open")
            
        } else if status == "ASSIGNED" || status == "IN_PROGRESS" || status == "SOLVED" || status == "DONE"{
            cell.cellImg.image = UIImage(named: "assigned")
            cell.statusLabel.text = "قيد التنفيذ"
            
        } else if status == "CLOSED" {
            cell.cellImg.image = UIImage(named: "solved")
            
        } else if status == "EXCLUDED" {
            cell.cellImg.image = UIImage(named: "closed-2")
            
        }
        // set the text from the data model
        
        let ticketID = self.ticketCell[indexPath.row].ticket.id
        self.convertEngNumToArabicNum(num: ticketID, textF: cell.ticketInfo)
        
        let ticketDate = self.ticketCell[indexPath.row].ticket.createdAt
        self.convertDateFormater(ticketDate!, textF: cell.dateLabel)
        
        return cell
    }
}
