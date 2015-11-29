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
