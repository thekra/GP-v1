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
  
    @IBOutlet weak var mv: GMSMapView!
    @IBOutlet weak var confirmButton: UIButton!
    var longitude = 0.0
    var latitude = 0.0
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
//    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
//        print("Latitude: \(location.latitude) Longitude: \(location.longitude)")
//    }
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
    //{
        
//        manager.delegate = self
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate
//            else {
//
//            return print("whha")
//
//        }
//        print("latitude = \(locValue.latitude) longitude =  \(locValue.longitude)")
//        if let location = locations.first{
//        print("Latitude: \(coordinate.latitude) Longitude: \(coordinate.longitude)")
        //}
    //}
    
}

extension mapViewController: BonsaiControllerDelegate {

// return the frame of your Bonsai View Controller
func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
//    print(containerViewFrame.height)
//    print(containerViewFrame.height / (4/3))
    return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 2), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
    
}

// return a Bonsai Controller with SlideIn or Bubble transition animator
func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

    // Slide animation from .left, .right, .top, .bottom
   return BonsaiController(fromDirection: .bottom, presentedViewController: presented, delegate: self)
    
    
    // or Bubble animation initiated from a view
    //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
}
}
