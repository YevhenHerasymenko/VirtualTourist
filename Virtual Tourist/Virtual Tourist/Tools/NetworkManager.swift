//
//  NetworkManager.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 29/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import Foundation

class NetworkManager {
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    static let sharedInstance = NetworkManager()
    static let imageCache = ImageCache()
    
    func getPhotos(longitude: Double, latitude: Double, page: Int, completionHandler: CompletionHander)  {
        let params: [String : AnyObject] = ["method": FlickrConstants.searchPhotosMethod,"format": "json", "api_key": FlickrConstants.key, "per_page" : 21, "page" : page, "extras": "url_m", "lat": latitude+20, "lon": longitude, "nojsoncallback": 1]
        let urlString = FlickrConstants.baseUrl + escapedParameters(params)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                //NetworkManager.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        task.resume()
        
    }
    
    // Parsing the JSON
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
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
