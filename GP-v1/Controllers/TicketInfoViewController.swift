//
//  TicketInfoViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TicketInfoViewController: UIViewController {
    
    @IBOutlet weak var ticketInfoView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var neighborhood: UILabel!
    @IBOutlet weak var descView: UITextView!
    // @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var showRatingB: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    
    var ticket: TicketCell?
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    var img_1_name = ""
    var img_2_name = ""
    var img_3_name = ""
    var img_4_name = ""
    var imagesCount = 0
    var ticket_id = 0
    var ratingCount = 0
    
    var picArr = [UIImageView]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketInfoView.layer.cornerRadius = 30
        descView.layer.cornerRadius = 30
        self.imagesCount = (ticket?[0].photos.count)!
        neighborhood.layer.masksToBounds = true
        neighborhood.layer.cornerRadius = 20
        //raitngCount = (ticket?[0].userRating.count)!
        deleteButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        rateButton.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        showRatingB.roundCorners(corners: [.topLeft, .topRight], radius: 15)
       // descLabel.layer.masksToBounds = true
        //descView.text = ticket?[0].ticket.ticketDescription
        
        if ticket?[0].ticket.ticketDescription == "." {
            descView.text = ""
        } else {
            descView.text = ticket?[0].ticket.ticketDescription
        }
        
        neighborhood.text = ticket?[0].location[0].neighborhood
        
        picArr = [pic_1, pic_2, pic_3, pic_4]
        
        loadImages()
        
        self.ticket_id = (ticket?[0].ticket.id)!
        
        checkForRating()
    }
    
   
    
    func checkForRating() {
        
        if ticket?[0].ticket.status == "CLOSED" {
            deleteButton.isHidden = true
            print("user rating : \(ticket?[0].userRating.count)")
            //self.raitngCount = (ticket?[0].userRating.count)!
            if ticket?[0].userRating.count == 0 {
                rateButton.isHidden = false
                showRatingB.isHidden = true
            } else {
                rateButton.isHidden = true
                showRatingB.isHidden = false
                
            }
            
        } else {
            deleteButton.isHidden = false
            rateButton.isHidden = true
            showRatingB.isHidden = true
        }
    }
    
    @IBAction func deleteTicket(_ sender: Any) {
        
    }
    
    @IBAction func ratePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "rate") as! rateViewController
        vc.ticket_id = ticket_id
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showRatingPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showRate") as! showRateViewController
               vc.ticket_id = ticket_id
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
        let urlString = "http://www.ai-rdm.website/storage/photos/\(img)"
        
         let i = self.startAnActivityIndicator()
        
    if Connectivity.isConnectedToInternet {
        Alamofire.request(urlString, method: .get).responseImage { response in
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

            }
            }
            
        } // end of interent check
    }
   
    
}



