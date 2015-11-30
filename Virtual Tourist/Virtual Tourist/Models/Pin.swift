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

}
