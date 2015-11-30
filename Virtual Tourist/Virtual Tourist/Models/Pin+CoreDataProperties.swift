//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 30/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var photos: NSSet?

}
