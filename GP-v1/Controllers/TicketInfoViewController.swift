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
    @IBOutlet weak var ticketDesc: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var neighborhood: UILabel!
    
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    
    var ticket: TicketCell?
    var token: String = UserDefaults.standard.string(forKey: "access_token")!
    
    var img_1 = ""
    var img_2 = ""
    var img_3 = ""
    var img_4 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketInfoView.layer.cornerRadius = 30
        ticketDesc.layer.cornerRadius = 30
        neighborhood.layer.cornerRadius = 30
        deleteButton.roundCorners(corners:  [.topLeft, .topRight], radius: 15)
        
        ticketDesc.text = ticket?[0].ticket.ticketDescription
        neighborhood.text = ticket?[0].location[0].neighborhood
        showImages()
        
        
    }
    
    func setImage(img: String, pic: UIImageView) {
        //var images = [Data]()
        let urlString = "http://www.ai-rdm.website/storage/photos/\(img)"
        Alamofire.request(urlString, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            print("Image: \(image)")
            // Do stuff with your image
            pic.image = image
        }
    }
    
    //    func imageNumber(num: Int, img: String) {
    //       var img = (ticket?[0].photos[num].photoName)!
    //    }
    
    func showImages() {
        print("photos count: \(String(describing: ticket?[0].photos.count))")
        
        
        if ticket?[0].photos.count == 1 {
            self.img_1 = (ticket?[0].photos[0].photoName)!
            setImage(img: self.img_1, pic: self.pic_1)
        }
        
        if ticket?[0].photos.count == 2 {
            print("photos count 2: \(String(describing: ticket?[0].photos.count))")
            self.img_1 = (ticket?[0].photos[0].photoName)!
            self.img_2 = (ticket?[0].photos[1].photoName)!
            if self.img_2.hasSuffix("jpeg") {
                setImage(img: self.img_1, pic: self.pic_1)
                setImage(img: self.img_2, pic: self.pic_2)
            }
        }
        
        if ticket?[0].photos.count == 3 {
            print("photos count 3: \(String(describing: ticket?[0].photos.count))")
            self.img_1 = (ticket?[0].photos[0].photoName)!
            self.img_2 = (ticket?[0].photos[1].photoName)!
            self.img_3 = (ticket?[0].photos[2].photoName)!
            if self.img_3.hasSuffix("jpeg") {
                setImage(img: self.img_1, pic: self.pic_1)
                setImage(img: self.img_2, pic: self.pic_2)
                setImage(img: self.img_3, pic: self.pic_3)
            }
        }
        // Don't know why it counts it 5 although it's 4
        if ticket?[0].photos.count == 5 {
            print("photos count 4: \(String(describing: ticket?[0].photos.count))")
            self.img_1 = (ticket?[0].photos[0].photoName)!
            self.img_2 = (ticket?[0].photos[1].photoName)!
            self.img_3 = (ticket?[0].photos[2].photoName)!
            self.img_4 = (ticket?[0].photos[3].photoName)!
            if self.img_4.hasSuffix("jpeg") {
                setImage(img: self.img_1, pic: self.pic_1)
                setImage(img: self.img_2, pic: self.pic_2)
                setImage(img: self.img_3, pic: self.pic_3)
                setImage(img: self.img_4, pic: self.pic_4)
            }
        }
    }
}



