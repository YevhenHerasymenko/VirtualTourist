//
//  PinPhotosViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MapKit

class PinPhotosViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "OK", style: .Plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }

}
