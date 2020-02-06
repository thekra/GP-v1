//
//  mapViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 12/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import GoogleMaps

class mapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func loadView() {
       
      // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
      let camera = GMSCameraPosition.camera(withLatitude: 21.422510, longitude: 39.826168, zoom: 6.0)
      let mapV = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
      view = mapV
        mapV.settings.compassButton = true
        mapV.isMyLocationEnabled = true
        mapV.settings.myLocationButton = true
        
      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: 39.826168, longitude: 39.826168)
      marker.title = "Mecca"
      marker.snippet = "Saudi Arabia"
      marker.map = mapView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

}

extension mapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("latitude = \(locValue.latitude) longitude =  \(locValue.longitude)")
    }
}
