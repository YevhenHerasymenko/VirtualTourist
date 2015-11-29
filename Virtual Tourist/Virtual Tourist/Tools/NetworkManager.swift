//
//  NetworkManager.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 29/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import Foundation

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    func getPhotos(longitude: Double, latitude: Double)  {
        let params: [String : AnyObject] = ["format": "json", "api_key": 100, "lat": latitude, "lon": longitude]
        let urlString = FlickrConstants.photosUrl + escapedParameters(params)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            do {
                let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
            } catch _ as NSError { }
        }
        task.resume()
        
    }
    
    //MARK: - Parameters
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}
