//
//  switchEmpViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 29/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire

class switchEmpViewController: UIViewController {
    
var token: String = UserDefaults.standard.string(forKey: "access_token")!
    @IBOutlet weak var hiEmp: UILabel!
    
    @IBOutlet weak var ticketsCount: UILabel!
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getCount()
        
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if self.isKeyPresentInUserDefaults(key: "name") == true {
                let namee = UserDefaults.standard.string(forKey: "name")!
                if namee.components(separatedBy: " ").filter({ !$0.isEmpty}).count == 1 {
                
                                            print("One word")
                
                                       hiEmp.text = "مرحباً، \(namee)" //UserDefaults.standard.set(namee, forKey: "name")
                
                                        } else {
                                            print("Not one word")
                    let firstName = namee.components(separatedBy: " ")
                
                                           hiEmp.text = "مرحباً، \(firstName[0])" //UserDefaults.standard.set(firstName[0], forKey: "name")
                                        }
                //let namee = UserDefaults.standard.string(forKey: "name")!
                 //hiUser.text = "مرحباً، \(namee)"
            } else {

                hiEmp.text = "مرحباً،"
            }
            getCount()
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
                    
                    let tCount = responseObject.ticketsCount
                    self.convertEngNumToArabicNum(num: tCount, textF: self.ticketsCount)
                    
                } // end of do
                catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
        @IBAction func signOut(_ sender: Any) {
            let urlString = "http://www.ai-rdm.website/api/auth/logout"

                   let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(self.token)",
                       "Content-Type": "multipart/form-data",
                       "Accept": "application/json"
                   ]

                   Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
                       response in

                       print(response.response!)

                       guard let data = response.data else {

                           DispatchQueue.main.async {
                               print(response.error!)
                           }
                           return
                       }
                    if response.response?.statusCode == 200 {
                        UserDefaults.standard.set(false, forKey: "isEmpLoggedIn")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signin") as! signinController
                                                                                self.present(vc, animated: true, completion: nil)
                        //self.navigationController?.popToRootViewController(animated: true)
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                        let vc = storyboard.instantiateViewController(withIdentifier: "signin") as! signinController
//                                                              self.present(vc, animated: true, completion: nil)

                   }
                     print("the response is : \(response)")
        }
        }
        
     
        
        @IBAction func ticketListButton(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableViewEmp") as! TicketsListEmpViewController
            self.present(vc, animated: true, completion: nil)
        }
        
    }

