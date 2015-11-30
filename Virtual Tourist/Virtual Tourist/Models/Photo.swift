//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 30/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var pin: Pin?
    @NSManaged var imagePath: String?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /**
     * 5. The two argument init method
     *
     * The Two argument Init method. The method has two goals:
     *  - insert the new Person into a Core Data Managed Object Context
     *  - initialze the Person's properties from a dictionary
     */
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Get the entity associated with the "Person" type.  This is an object that contains
        // the information from the Model.xcdatamodeld file. We will talk about this file in
        // Lesson 4.
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        
        // Now we can call an init method that we have inherited from NSManagedObject. Remember that
        // the Person class is a subclass of NSManagedObject. This inherited init method does the
        // work of "inserting" our object into the context that was passed in as a parameter
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        // After the Core Data work has been taken care of we can init the properties from the
        // dictionary. This works in the same way that it did before we started on Core Data
//        name = dictionary[Keys.Name] as! String
//        id = dictionary[Keys.ID] as! Int
//        imagePath = dictionary[Keys.ProfilePath] as? String
    }
    
    var image: UIImage? {
        get {
            return NetworkManager.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            NetworkManager.imageCache.storeImage(image, withIdentifier: imagePath!)
        }
    }

}
