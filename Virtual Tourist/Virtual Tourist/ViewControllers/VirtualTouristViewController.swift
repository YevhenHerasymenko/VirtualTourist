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
    
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBottomViewConstraint.constant = 0
        setupRecognizer()
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    // Mark: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
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
        NetworkManager.sharedInstance.getPhotos(touchMapCoordinate.longitude, latitude: touchMapCoordinate.latitude) { (result, error) -> Void in
            if (error != nil) {
                self.showAlert((error?.description)!)
            } else {
                if let resultDictionaries = result.valueForKey("photos") as? [String : AnyObject] {
                    if let photoDictionaries = resultDictionaries["photo"] as? [[String : AnyObject]] {
                        let pin: Pin = Pin(longitude: touchMapCoordinate.longitude, latitude: touchMapCoordinate.latitude, photosDictionary: photoDictionaries, context: self.sharedContext)
                        self.pins.append(pin)
                        CoreDataStackManager.sharedInstance.saveContext()
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
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
    
    //MARK: - Alert
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let alertOkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alertOkAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
