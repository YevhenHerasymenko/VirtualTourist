//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 30/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var photos: NSSet?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(longitude: Double, latitude: Double, /*photosDictionary: [[String : AnyObject]],*/ context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        self.longitude = longitude
        self.latitude = latitude
        id = Int(NSDate().timeIntervalSince1970.description)
        loadPhotos(context, page: 1)
    }
    
    func loadPhotos(context: NSManagedObjectContext, page: Int) {
        NetworkManager.sharedInstance.getPhotos((longitude?.doubleValue)!, latitude: (latitude?.doubleValue)!, page: page) { (result, error) -> Void in
            if (error != nil) {
                //self.showAlert((error?.description)!)
            } else {
                if let resultDictionaries = result.valueForKey("photos") as? [String : AnyObject] {
                    if let photoDictionaries = resultDictionaries["photo"] as? [[String : AnyObject]] {
                        let photos = photoDictionaries.map() {
                            Photo(dictionary: $0, context: context)
                        }
                        self.photos = Set(photos)
                        dispatch_async(dispatch_get_main_queue()) {
                            CoreDataStackManager.sharedInstance.saveContext()
                        }
                    }
                }
            }
        }
    }
}
