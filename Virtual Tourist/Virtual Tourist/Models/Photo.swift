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
    
    typealias ImageHander = (image: UIImage) -> Void
    
    struct Keys {
        static let Title = "title"
        static let Url = "url_m"
        static let ID = "id"
    }

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var pin: Pin?
    @NSManaged var imagePath: String?
    
    var loadedImage: ImageHander!
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        

        super.init(entity: entity,insertIntoManagedObjectContext: context)
        

        title = dictionary[Keys.Title] as? String
        id = dictionary[Keys.ID] as? String
        imagePath = dictionary[Keys.Url] as? String
        downloadImage(NSURL(string: imagePath!)!)

    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
                guard let data = data where error == nil else { return }
                let loadImage = UIImage(data: data)
                self.image = loadImage
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    override func prepareForDeletion() {
        
    }
    
    var image: UIImage? {
        get {
            return NetworkManager.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            NetworkManager.imageCache.storeImage(newValue, withIdentifier: imagePath!)
            if let loadedImage = loadedImage {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    loadedImage(image: newValue!)
                }
                
            }
        }
    }

}
