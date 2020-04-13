//
//  TicketInfoEmpViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 01/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire
import  AlamofireImage

class TicketInfoEmpViewController: UIViewController {


        @IBOutlet weak var ticketInfoView: UIView!
        @IBOutlet weak var pic_1: UIImageView!
        @IBOutlet weak var pic_2: UIImageView!
        @IBOutlet weak var pic_3: UIImageView!
        @IBOutlet weak var pic_4: UIImageView!
        @IBOutlet weak var scrollView: UIScrollView!
        
        @IBOutlet weak var neighborhood: UILabel!
        @IBOutlet weak var descView: UILabel!
        @IBOutlet weak var nextButton: UIButton!
        
    @IBOutlet weak var googleMaps: UIButton!
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.imagesCount = (ticket?[0].photos.count)!
            if ticket?[0].ticket.ticketDescription == "." {
                       descView.text = ""
                   } else {
                       descView.text = ticket?[0].ticket.ticketDescription
                   }
                   
                   neighborhood.text = ticket?[0].location[0].neighborhood
                   
                   picArr = [pic_1, pic_2, pic_3, pic_4]
                   
                   loadImages()
                   
                   self.ticket_id = (ticket?[0].ticket.id)!
                   
                    // checkForRating()
        }
        
        var ticket: TicketCell?
       
        var imagesCount = 0
        var ticket_id = 0
    var latitude = 0.0
    var longitude = 0.0
    
        var picArr = [UIImageView]()
        var images = [UIImage]()
        var hasLoaded: Bool = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setUI()
            if ticket?[0].ticket.ticketDescription == "." {
                descView.text = ""
            } else {
                descView.text = ticket?[0].ticket.ticketDescription
            }
            
            neighborhood.text = ticket?[0].location[0].neighborhood
            
            longitude = Double((ticket?[0].location[0].longitude)!)!
            latitude = Double((ticket?[0].location[0].latitude)!)!
            googleMaps.setTitle("http://maps.google.com/maps?q=\(latitude),\(longitude)", for: .normal)
            picArr = [pic_1, pic_2, pic_3, pic_4]
            loadImages()

        checkForStatus()
        }
    
    
    func setUI() {
        ticketInfoView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        scrollView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        descView.layer.masksToBounds = true
        descView.layer.cornerRadius = 20
        
        neighborhood.layer.masksToBounds = true
        neighborhood.layer.cornerRadius = 20
        googleMaps.layer.cornerRadius = 20
        
        nextButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
    }
    func openGoogleMaps() {
        guard let lat = ticket?[0].location[0].latitude, let latDouble =  Double(lat) else {
            self.showAlert(title: "", message: "Location is wrong"); return }
        
        guard let long = ticket?[0].location[0].longitude, let longDouble =  Double(long) else {
        self.showAlert(title: "", message: "Location is wrong"); return }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)") {
                          UIApplication.shared.open(url, options: [:])
                 }}
            else {
                   //Open in browser
                  if let urlDestination = URL.init(string: "http://maps.google.com/maps?q=\(latDouble),\(longDouble)") {
                                     UIApplication.shared.open(urlDestination)
                                 }
                      }
    }
    
    func checkForStatus() {
        let status = ticket?[0].ticket.status
        
        if status == "IN_PROGRESS" {
            nextButton.isHidden = false
            
        } else {
            nextButton.isHidden = true
            
            
        }
    }

    @IBAction func goToGoogleMaps(_ sender: Any) {
        openGoogleMaps()
    }
    
        @IBAction func nextPressed(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "closeTicket") as! closeTicketViewController
           vc.ticket_id = ticket_id
//            vc.ticket = self.ticket
            self.present(vc, animated: true, completion: nil)
    }

        func loadImages() {
            
            for k in 0..<self.imagesCount {
                
                for i in (ticket?[0].photos[k].roleID)! {
                    if i == "1" {
                        let img_name = ticket?[0].photos[k].photoName
                        setImage(img: img_name!, count: k)
                    }
                }
            }
        }
        
        func setImage(img: String, count: Int)  {
            let urlString = URLs.get_image + "\(img)"
            
             let i = self.startAnActivityIndicator()
            
        if Connectivity.isConnectedToInternet {
            Alamofire.request(urlString, method: .get ).responseImage { response in
                guard let image = response.result.value else {
                    // Handle error
                    return
                }
                print("Image: \(image)")
                // Do stuff with your image
                if case .success(let image) = response.result {
                    i.stopAnimating()
                    print("image downloaded: \(image)")
                    
                           self.picArr[count].image =  image
                          // self.images[count] = image
                }
                }
                
            } // end of interent check
        }
       
        
    }



