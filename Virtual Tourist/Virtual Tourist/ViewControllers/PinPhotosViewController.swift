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
    
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    
    var selectedIndexes: [NSIndexPath]!
    
    var page: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        page = 2
        let backButton = UIBarButtonItem(title: "OK", style: .Plain, target: nil, action: nil)
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        setupMapView()
        bottomButton.addTarget(self, action: "loadNewCollection", forControlEvents: UIControlEvents.TouchUpInside)
        collectionView.allowsMultipleSelection = true
        selectedIndexes = Array<NSIndexPath>()
        noImageLabel.hidden = !pin.photos.isEmpty
        bottomButton.enabled = !pin.photos.isEmpty
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
        return fetchedResultsController.sections![section].numberOfObjects //pin.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell: PhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        photoCell.configure(fetchedResultsController.objectAtIndexPath(indexPath) as! Photo)
        if selectedIndexes.contains(indexPath) {
            photoCell.selectView.hidden = false
            photoCell.selected = true
        }
        return photoCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoCell: PhotoCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        photoCell.selectView.hidden = false
        selectedIndexes.append(indexPath)
        if selectedIndexes.count == 1 {
            bottomButton.removeTarget(self, action: "loadNewCollection", forControlEvents: UIControlEvents.TouchUpInside)
            bottomButton.addTarget(self, action: "removePhotos", forControlEvents: UIControlEvents.TouchUpInside)
            bottomButton.setTitle("Remove Selected Pictures", forState: UIControlState.Normal)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let photoCell: PhotoCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        photoCell.selectView.hidden = true
        
        selectedIndexes.removeAtIndex(selectedIndexes.indexOf(indexPath)!)
    }
    
    //MARK: - Actions
    
    func loadNewCollection() {
        for photo in pin.photos {
            sharedContext.deleteObject(photo)
        }
        CoreDataStackManager.sharedInstance.saveContext()
        collectionView.reloadData()
        pin.loadPhotos(sharedContext, page: page)
        page = page + 1
    }
    
    func removePhotos() {
        collectionView.performBatchUpdates({ () -> Void in
            var photos = Array<Photo>()
            for indexPath in self.selectedIndexes {
                let photo = self.fetchedResultsController.objectAtIndexPath(indexPath)
                photos.append(photo as! Photo)
                
     
            }
            for photo in photos {
                self.sharedContext.deleteObject(photo)
            }
            CoreDataStackManager.sharedInstance.saveContext()
            self.collectionView.deleteItemsAtIndexPaths(self.selectedIndexes)
            self.selectedIndexes.removeAll()
            }) { (success) -> Void in
                CoreDataStackManager.sharedInstance.saveContext()
                self.bottomButton.removeTarget(self, action: "removePhotos", forControlEvents: UIControlEvents.TouchUpInside)
                self.bottomButton.addTarget(self, action: "loadNewCollection", forControlEvents: UIControlEvents.TouchUpInside)
                self.bottomButton.setTitle("New Collection", forState: UIControlState.Normal)
        }
    }
    
    
    //MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "pin = %@", self.pin);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert {
            collectionView.reloadData()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    }

}
