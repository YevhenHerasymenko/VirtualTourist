//
//  VirtualTouristViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MapKit

class VirtualTouristViewController: UIViewController {

    @IBOutlet weak var rightItem: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heightBottomViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBottomViewConstraint.constant = 0
    }
    
    //MARK: - Actions

    @IBAction func edit(sender: UIBarButtonItem) {
        heightBottomViewConstraint.constant = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done:")
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        heightBottomViewConstraint.constant = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit:")
    }
    
    
}
