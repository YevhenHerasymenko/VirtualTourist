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
    
    init(longitude: Double, latitude: Double, photosDictionary: [[String : AnyObject]], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        self.longitude = longitude
        self.latitude = latitude
        id = Int(NSDate().timeIntervalSince1970.description)
        let photos = photosDictionary.map() {
            Photo(dictionary: $0, context: context)
        }
        self.photos = Set(photos)
    }
}
