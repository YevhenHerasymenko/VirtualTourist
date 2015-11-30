//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var data: NSData?
    @NSManaged var pin: Pin?

}
