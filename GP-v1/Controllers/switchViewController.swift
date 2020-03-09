//
//  switchViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 10/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class switchViewController: UIViewController {

    @IBOutlet weak var ticketsCount: UILabel!
    @IBOutlet weak var hiUser: UILabel!
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCount()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "name") == true {
            let namee = UserDefaults.standard.string(forKey: "name")!
             hiUser.text = "مرحباً، \(namee)"
        } else {

            hiUser.text = "مرحباً،"
        }
        
        getCount()
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getCount() {
        let urlString = "http://www.ai-rdm.website/api/ticket/ticketsCount"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token)",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
           
            
            print("Count: \(response)")
            
            guard let data = response.data else {
                
                DispatchQueue.main.async {
                    print("Response async error \(response.error!)")
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let responseObject =  try decoder.decode(TicketsCount.self, from: data)
                
                self.ticketsCount.text =  String(responseObject.ticketsCount)
                
            } // end of do
            catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
//        let urlString = "http://www.ai-rdm.website/api/auth/logout"
//
//               let headers: HTTPHeaders = [
//                   "Authorization": "Bearer \(self.token)",
//                   "Content-Type": "multipart/form-data",
//                   "Accept": "application/json"
//               ]
//
//               Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
//                   response in
//
//                   print(response.response!)
//
//                   guard let data = response.data else {
//
//                       DispatchQueue.main.async {
//                           print(response.error!)
//                       }
//                       return
//                   }
//
//               }
        UserDefaults.standard.removeObject(forKey: "access_token")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signin") as! signinController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToMap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! mapViewController
               self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func profile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userProfilee") as! userProfileViewController
                      self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ticketListButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
