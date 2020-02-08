//
//  mapContainerViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 14/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit
import GoogleMaps

class mapContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: 21.422510, longitude: 39.826168, zoom: 12)
        let mapV = GMSMapView.map(withFrame: .zero, camera: camera)
        mapV.settings.compassButton = true
        mapV.isMyLocationEnabled = true
        mapV.settings.myLocationButton = true
        self.view = mapV
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
