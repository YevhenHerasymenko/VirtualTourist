//
//  PinPhotosViewController.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    var photos: [Photo]!
    
    var page: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        page = 2
        self.photos = pin.photos?.allObjects as! [Photo]
        let backButton = UIBarButtonItem(title: "OK", style: .Plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        fetchedResultsController.delegate = self
        setupMapView()
        bottomButton.addTarget(self, action: "loadNewCollection", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupMapView() {
        let annotation = MKPointAnnotation()
        let latitude = pin.latitude?.doubleValue
        let longitude = pin.longitude?.doubleValue
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        mapView.addAnnotation(annotation)
        mapView.region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(1, 1))
        mapView.centerCoordinate = annotation.coordinate
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    //MARK: - Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell: PhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        photoCell.configure(photos[indexPath.row])
        return photoCell
    }
    
    //MARK: - Actions
    
    func loadNewCollection() {
        pin.loadPhotos(sharedContext, page: page)
    }
    
    
    //MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "self == %@", self.pin);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }

}
