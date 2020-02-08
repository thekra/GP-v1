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

    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func loadView() {
       
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 39.826168, longitude: 39.826168)
//        marker.title = "Mecca"
//        marker.snippet = "Saudi Arabia"
//        marker.map = mapView

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         //self.view.insertSubview(mapView, at: 0)
       let camera = GMSCameraPosition.camera(withLatitude: 21.422510, longitude: 39.826168, zoom: 12)

        let mapV = GMSMapView.map(withFrame: .zero, camera: camera)
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 90, right: 0)
        mapV.padding = mapInsets
        mapV.settings.compassButton = true
        mapV.isMyLocationEnabled = true
        mapV.settings.myLocationButton = true
               view = mapV
        
        let revealButton = UIButton()
        let btnImage = UIImage(named: "conform_location")
        revealButton.setImage(btnImage, for: .normal)
        //revealButton.frame = CGRect(x: 0, y: 0, width: 750, height: 185)
        revealButton.frame = CGRect(x: -170, y: 735, width: 750, height: 185)
        revealButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
        self.view.addSubview(revealButton)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ticket") as! ticketViewController
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }

}

extension mapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("latitude = \(locValue.latitude) longitude =  \(locValue.longitude)")
    }
}

extension mapViewController: BonsaiControllerDelegate {

// return the frame of your Bonsai View Controller
func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
    
    return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 2.5), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
}

// return a Bonsai Controller with SlideIn or Bubble transition animator
func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

    // Slide animation from .left, .right, .top, .bottom
   return BonsaiController(fromDirection: .bottom, presentedViewController: presented, delegate: self)
    
    
    // or Bubble animation initiated from a view
    //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
}
}
