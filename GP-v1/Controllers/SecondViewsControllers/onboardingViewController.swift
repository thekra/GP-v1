//
//  onboardingViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 12/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import CoreLocation

class onboardingViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
    }
    @objc func imageTap() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! mapViewController
        self.present(vc, animated: true, completion: nil)
        
        let locStatus = CLLocationManager.authorizationStatus()
        
        switch locStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    //    @IBAction func pressed(_ sender: UIButton) {
    //        performSegue(withIdentifier: "test", sender: nil)
    //    }
    
}
