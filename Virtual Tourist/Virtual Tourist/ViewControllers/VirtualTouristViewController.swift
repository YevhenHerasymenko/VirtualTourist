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
    var isRemoving: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBottomViewConstraint.constant = 0
        setupRecognizer()
    }
    
    //MARK: - Recognizer
    
    func setupRecognizer() {
        longPressAddPinRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressAddPinRecognizer:")
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
    
    //MARK: - Actions

    @IBAction func edit(sender: UIBarButtonItem) {
        mapView.removeGestureRecognizer(longPressAddPinRecognizer)
        heightBottomViewConstraint.constant = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done:")
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        mapView.addGestureRecognizer(longPressAddPinRecognizer)
        heightBottomViewConstraint.constant = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit:")
    }
    
    //MARK: - MapView Delegate
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        performSegueWithIdentifier(SegueConstants.detailsSegue, sender: view)
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
    
}
