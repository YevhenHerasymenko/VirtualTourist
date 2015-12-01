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
    
    struct Keys {
        static let Title = "title"
        static let Url = "url_m"
        static let ID = "id"
    }

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var pin: Pin?
    @NSManaged var imagePath: String?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        

        super.init(entity: entity,insertIntoManagedObjectContext: context)
        

        title = dictionary[Keys.Title] as? String
        id = dictionary[Keys.ID] as? String
        imagePath = dictionary[Keys.Url] as? String
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
