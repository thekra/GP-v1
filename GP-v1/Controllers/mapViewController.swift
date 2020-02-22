//
//  mapViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 12/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import GoogleMaps
import BonsaiController

class mapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mv: GMSMapView!
    @IBOutlet weak var confirmButton: UIButton!
    var longitude = 0.0
    var latitude = 0.0
    var token = UserDefaults.standard.string(forKey: "access_token")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Token(mapViewDidLoad): \(self.token)")
        
        let camera = GMSCameraPosition.camera(withLatitude: 21.422510, longitude: 39.826168, zoom: 12)
        mv.camera = camera
        mv.settings.compassButton = true
        mv.isMyLocationEnabled = true
        mv.settings.myLocationButton = true
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 21.422510, longitude: 39.826168)
        marker.title = "Mecca"
        marker.snippet = "Saudi Arabia"
        marker.map = mv
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
    }
    
    @objc func imageTap() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as! ticketListViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ticket") as! ticketViewController
        
        vc.latitude = self.latitude
        vc.longitude = self.longitude
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
        
    }
}



extension mapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17)
        
        self.mv?.animate(to: camera)
        
        print("Latitude: ")
        print((Double(location?.coordinate.latitude ?? 0.0)))
        
        print("Longitude: ")
        print((Double(location?.coordinate.longitude ?? 0.0)))
        
        self.longitude = (Double(location?.coordinate.longitude ?? 0.0))
        self.latitude = (Double(location?.coordinate.latitude ?? 0.0))
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
}

extension mapViewController: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        //    print(containerViewFrame.height)
        //    print(containerViewFrame.height / (4/3))
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 3), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
        
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, presentedViewController: presented, delegate: self)
        
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}
