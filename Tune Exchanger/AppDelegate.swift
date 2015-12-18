//
//  AppDelegate.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 07/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack()
    //test
    //let delegate = UIApplication.sharedApplication().delegate as? AppDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let tabBarController = window!.rootViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers?.first as! UINavigationController
        let viewController1 = navigationController.topViewController as! TunebookTableViewController
        viewController1.managedContext = coreDataStack.context
        let navigationControllerTunesLink = tabBarController.viewControllers?.last as! UINavigationController
        let viewController2 = navigationControllerTunesLink.topViewController as! TunesTableViewController
        viewController2.managedContext = coreDataStack.context
        importJSONTuneSeedDataIfNeeded()
        importJSONTunebookSeedDataIfNeeded()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    
    }

    func applicationDidEnterBackground(application: UIApplication) {
            coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }

    func importJSONTunebookSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest(entityName: "Tunebook")
        var error:NSError? = nil
        let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: &error)
        if count == 0 {
            if let jsonSeedDataUrl = NSBundle.mainBundle().URLForResource("seedTunebooks", withExtension: "json"){
                let result = Tunebook.importJSONTunebookFile(jsonSeedDataUrl, coreDataStack: coreDataStack)
                if result == true {
                    print ("Data from \(jsonSeedDataUrl) imported successfully")
                } else {
                    print ("Data from \(jsonSeedDataUrl) not imported")
                }
            }
        }
        
    }
    
func importJSONTuneSeedDataIfNeeded() {
    
    let fetchRequest = NSFetchRequest(entityName: "Tune")
    var error:NSError? = nil
    let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: &error)
    if count == 0 {
        if let jsonSeedDataUrl = NSBundle.mainBundle().URLForResource("seedTunes", withExtension: "json")
        {
            let result = Tune.importJSONTuneFile(jsonSeedDataUrl, coreDataStack: coreDataStack) }
    }
}


}

































