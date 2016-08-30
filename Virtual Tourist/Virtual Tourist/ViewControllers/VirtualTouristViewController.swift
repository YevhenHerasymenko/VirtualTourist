//
//  VirtualTouristViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MapKit
import CoreData

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
        let request = NSFetchRequest(entityName: "Pin")
        do {
            let pins: [Pin] = try sharedContext.executeFetchRequest(request) as! [Pin]
            var annotations = Array<MKPointAnnotation>()
            for pin in pins {
                let annotation = MKPointAnnotation()
                let latitude = pin.latitude?.doubleValue
                let longitude = pin.longitude?.doubleValue
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        } catch let error as NSError {
            showAlert(error.description)
        }
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    //MARK: - Recognizer
    
    func setupRecognizer() {
        longPressAddPinRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(VirtualTouristViewController.longPressAddPinRecognizer(_:)))
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
        _ = Pin(longitude: touchMapCoordinate.longitude,
                latitude: touchMapCoordinate.latitude,
                context: self.sharedContext)
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK: - Actions

    @IBAction func edit(sender: UIBarButtonItem) {
        mapView.removeGestureRecognizer(longPressAddPinRecognizer)
        heightBottomViewConstraint.constant = 60
        isRemoving = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done:")
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        mapView.addGestureRecognizer(longPressAddPinRecognizer)
        heightBottomViewConstraint.constant = 0
        isRemoving = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(VirtualTouristViewController.edit(_:)))
    }
    
    //MARK: - MapView Delegate
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation
        let request = NSFetchRequest(entityName: "Pin")
        let latitude = 0//NSNumber(double: (annotation?.coordinate.latitude)!)
        let longitude = NSNumber(double: (annotation?.coordinate.longitude)!)
        request.predicate = NSPredicate(format: "latitude == %@ AND longitud == %@", latitude, longitude)
        do {
            let pins: [Pin] = try sharedContext.executeFetchRequest(request) as! [Pin]
            let pin = pins[0]
            if isRemoving {
                sharedContext.deleteObject(pin)
                CoreDataStackManager.sharedInstance.saveContext()
                mapView.removeAnnotation(annotation!)
            } else {
                performSegueWithIdentifier(SegueConstants.detailsSegue, sender: pin)
                mapView.deselectAnnotation(annotation, animated: true)
            }

        } catch let error as NSError {
            showAlert(error.description)
        }
        
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photosController = segue.destinationViewController as! PinPhotosViewController
        //photosController.pin = sender as! Pin
    }
    
    //MARK: - Alert
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let alertOkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alertOkAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
