//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 28/11/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        CoreDataStackManager.sharedInstance().saveContext()
    }
}

