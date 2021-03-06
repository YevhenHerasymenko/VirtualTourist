//
//  File.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class ImageCache {
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        // If the image is nil, remove images from the cache
        if image == nil {
            deleteImage(identifier)
            return
        }
        let path = pathForIdentifier(identifier)
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
    }
    
    // MARK: - Deleting image
    
    func deleteImage(identifier: String) {
        let path = pathForIdentifier(identifier)
        inMemoryCache.removeObjectForKey(path)
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch _ {}
        
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let urlIdentifier = NSURL(string: identifier)
        var urlPath = urlIdentifier?.path
        urlPath = urlPath?.stringByReplacingOccurrencesOfString("/", withString: "")
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(urlPath!)
        
        return fullURL.path!
    }
}