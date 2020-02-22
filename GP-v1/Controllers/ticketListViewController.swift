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
    //var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getTicketsList()
        //startTimer()
        tableView.layer.cornerRadius = 30
        
    }
//    func startTimer() {
////        let timer =
//        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.getTicketsList), userInfo: nil, repeats: true)
//        //timer.invalidate()
//    }
    
    @objc func getTicketsList() {
        
        //var temp = TicketCell()
        
        let urlString = "http://www.ai-rdm.website/api/ticket/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            let result = response.result.value as? [[String : AnyObject]]
            print("Result ticket cell: \(result!)")
            
            print("Response ticket cell: \(response.response!)")
            
            guard let data = response.data else {
                
                DispatchQueue.main.async {
                    print("Response async error \(response.error!)")
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject =  try decoder.decode(TicketCell.self, from: data)
                //temp = responseObject
                self.ticketCell = responseObject
               // if temp.isEmpty {
                if self.ticketCell.isEmpty {
                    self.showAlert(title: "لا شيء", message: "لا يوجد لديك تذاكر")
                }
                print("Ticket Cell: \(self.ticketCell)")
                
                
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
            DispatchQueue.main.async {
               // self.ticketCell = temp
                self.tableView.reloadData()
                //self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.getTicketsList), userInfo: nil, repeats: false)
            }
        }
        
    }
//
//    deinit {
//        self.timer.invalidate()
//    }
    
    @IBAction func goBack(_ sender: Any) {
        go()
    }
    
    func go() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! mapViewController
        self.present(vc, animated: true, completion: nil)
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
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let des = segue.destination as? TicketInfoViewController {
            des.ticket = [ticketCell[(tableView.indexPathForSelectedRow?.row)!]]
        }
        
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
