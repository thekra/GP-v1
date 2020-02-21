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
    
    @IBOutlet weak var tableView: UITableView!
    
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    var ticketCell = TicketCell()
    var ticketID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTicketsList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 30
        
    }
    
    
    func getTicketsList() {
        
        let urlString = "http://www.ai-rdm.website/api/ticket/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            let result = response.result.value as? [[String : AnyObject]]
            print(result!)
            
            print(response.response!)
            
            guard let data = response.data else {

                DispatchQueue.main.async {
                    print(response.error!)
                }
                return
            }
             let decoder = JSONDecoder()
                       do {
                        let responseObject =  try decoder.decode(TicketCell.self, from: data)
                        self.ticketCell = responseObject
                        print("Ticket Cell: \(self.ticketCell)")
                        
                        
             } // end of do
             catch let parsingError {
                     print("Error", parsingError)
             }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    

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
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ticketListTableViewCell

        // set the text from the data model
        
        cell.ticketInfo.text = "\(self.ticketCell[indexPath.row].ticket.id)معلومات التذكرة"

        return cell
    }
}
