//
//  VirtualTouristViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MapKit

class VirtualTouristViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var rightItem: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heightBottomViewConstraint: NSLayoutConstraint!
    
    var longPressAddPinRecognizer: UILongPressGestureRecognizer!
    var tapRemovePinRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBottomViewConstraint.constant = 0
        setupRecognizer()
    }
    
    //MARK: - Recognizer
    
    func setupRecognizer() {
        longPressAddPinRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAddPinRecognizer:")
        tapRemovePinRecognizer = UITapGestureRecognizer(target: self, action: "tapRemovePinRecognizer:")
        mapView.addGestureRecognizer(longPressAddPinRecognizer)
    }
    
    func longPressAddPinRecognizer(recognizer: UIGestureRecognizer) {
        if recognizer.state != UIGestureRecognizerState.Began {
            return
        }
        
        let touchPoint: CGPoint = recognizer.locationInView(mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
    }
    
    func tapRemovePinRecognizer(recognizer: UIGestureRecognizer) {
        
    }
    
    //MARK: - Actions

    @IBAction func edit(sender: UIBarButtonItem) {
        mapView.removeGestureRecognizer(longPressAddPinRecognizer)
        mapView.addGestureRecognizer(tapRemovePinRecognizer)
        heightBottomViewConstraint.constant = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done:")
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        mapView.removeGestureRecognizer(tapRemovePinRecognizer)
        mapView.addGestureRecognizer(longPressAddPinRecognizer)
        heightBottomViewConstraint.constant = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit:")
    }
    
    
}
