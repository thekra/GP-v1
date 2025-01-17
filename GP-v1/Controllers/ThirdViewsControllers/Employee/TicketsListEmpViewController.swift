//
//  TicketsListEmpViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 29/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class TicketsListEmpViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableViewEmp: UITableView!
    @IBOutlet weak var noTicketsLabel: UILabel!
    
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
            
            
            tableViewEmp.delegate = self
            tableViewEmp.dataSource = self
            getTicketsList()
            bottomView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
            noTicketsLabel.isHidden = true
            addRefresh()
        }
        
        func addRefresh() {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refreshlist), for: .valueChanged)
            tableViewEmp.addSubview(refreshControl!)
        }
        
        @objc func refreshlist() {
            refreshControl?.endRefreshing()
            getTicketsList()
        }
        
        @objc func getTicketsList() {
            
            let urlString = URLs.tickets_list
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(self.token)",
                "Content-Type": "multipart/form-data",
                "Accept": "application/json"
            ]
             let i = self.startAnActivityIndicator()
        if Connectivity.isConnectedToInternet {
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
                response in
                
                guard let data = response.data else {
                    
                    DispatchQueue.main.async {
                        print("Response async error \(response.error!)")
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    
                    let responseObject =  try decoder.decode(TicketCell.self, from: data)
                    
                    self.ticketCell = responseObject
                    
                    if self.ticketCell.isEmpty {
                        i.stopAnimating()
                        self.noTicketsLabel.isHidden = false
                    }
                    
                    print("Ticket Cell: \(self.ticketCell)")
                    
                    
                } // end of do
                catch let parsingError {
                    print("Error", parsingError)
                }
                
                DispatchQueue.main.async {
                    i.stopAnimating()
                    self.tableViewEmp.reloadData()
                    
                }
            } // end of alamofire
            
        } else {
            //self.showAlert(title: "خطأ", message: "لا يوجد اتصال بالانترنت")
            i.stopAnimating()
            AlertView.instance.showAlert(message: "لا يوجد اتصال بالانترنت", alertType: .failure)
            self.view.addSubview(AlertView.instance.ParentView)
            } // end of else connection
            
    } // end of function
        
    } // end of class

    extension TicketsListEmpViewController:  UITableViewDelegate, UITableViewDataSource {
        
        // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.ticketCell.count
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.ticketID = ticketCell[indexPath.row].ticket.id
            print("TicketID: \(ticketID)")
            print("You tapped cell number \(indexPath.row).")
            
            performSegue(withIdentifier: "showDetailss", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if let des = segue.destination as? TicketInfoEmpViewController {
                des.ticket = [ticketCell[(tableViewEmp.indexPathForSelectedRow?.row)!]]
                //des.ticket_id = ticketCell[indexPath.row].ticket.id
            }
            
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // create a new cell if needed or reuse an old one
            let cell = self.tableViewEmp.dequeueReusableCell(withIdentifier: "empCell") as! TicketsListEmpTableViewCell
            cell.ticketStatus.text = self.ticketCell[indexPath.row].ticket.statusAr
            let status = self.ticketCell[indexPath.row].ticket.status
            
            if status == "OPEN" {
                cell.ticketImg.image = UIImage(named: "open")
                
            } else if status == "ASSIGNED" || status == "IN_PROGRESS" || status == "SOLVED" || status == "DONE"{
                cell.ticketImg.image = UIImage(named: "assigned")
                cell.ticketStatus.text = "قيد التنفيذ"
                
            } else if status == "CLOSED" {
                cell.ticketImg.image = UIImage(named: "solved")
            
            } else if status == "EXCLUDED" {
                cell.ticketImg.image = UIImage(named: "closed-2")
                
            }
            // set the text from the data model
            
            let ticketID = self.ticketCell[indexPath.row].ticket.id
            self.convertEngNumToArabicNum(num: ticketID, textF: cell.ticketInfo)
            
            let ticketDate = self.ticketCell[indexPath.row].ticket.createdAt
            self.convertDateFormater(ticketDate!, textF: cell.ticketDate)
            
            return cell
        }
    }
