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
        importJSONTunebookSeedDataIfNeeded()
        //importJSONTuneSeedDataIfNeeded()
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
            importJSONSeedDataTunebook()
        }
        
    }

    
    func importJSONSeedDataTunebook() {
        let TunebookEntity = NSEntityDescription.entityForName("Tunebook", inManagedObjectContext: coreDataStack.context)
        let TuneEntity = NSEntityDescription.entityForName("Tune", inManagedObjectContext: coreDataStack.context)
        let SetEntity = NSEntityDescription.entityForName("Set", inManagedObjectContext: coreDataStack.context)
        let jsonURL = NSBundle.mainBundle().URLForResource("seedTunebooks", withExtension: "json")
        let json:JSON = JSON(data: NSData(contentsOfURL: jsonURL!)!)
        if let tunebookArray = json["tunebook"].array {  //get the tunebookArray
            for tunebook in tunebookArray {
                let tunebookData = Tunebook(entity: TunebookEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                tunebookData.title = tunebook["title"].string
                tunebookData.contentDescription = tunebook["contentDescription"].string
                print("title = \(tunebookData.title!), description = \(tunebookData.contentDescription!)")
                if let tunes = tunebook["tune"].array {
                    for tune in tunes {
                        let tuneData = Tune(entity: TuneEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                        tuneData.title = tune["title"].string
                        print("Tune: \(tuneData.title!)")
                    } //finished importing tunes directly in tunebook
                }// end import if there are no tunes in tunebook
                if let sets = tunebook["sets"].array {
                    for set in sets {
                        let setData = Set(entity: SetEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                        setData.title = set["title"].string
                        print("setTitle = \(setData.title!)")
                        let tunesInSet = set["tune"].array
                        for tuneInSet in tunesInSet! {
                            let tuneData = Tune(entity: TuneEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                            tuneData.title = tuneInSet["title"].string
                            print("tuneInSetTitle = \(tuneData.title!)")
                        } //end tuneInSet loop
                    }//end sets import loop
                }//end import if there are no sets in tunebook
                }//end of tunebook loop    
            coreDataStack.saveContext()
        } //end of if let tunebook
    }
    
            
//        do {
////            let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as! NSArray
////            let entity = NSEntityDescription.entityForName("Tunebook", inManagedObjectContext: coreDataStack.context)
////            
////            for jsonDictionary in jsonArray {
////                let contentDescription = jsonDictionary["contentDescription"] as! String
////                let title = jsonDictionary["title"] as! String
////                let tuneJson = jsonArray["tune"] as! NSArray
////                let tunebook = Tunebook(entity: entity!, insertIntoManagedObjectContext: coreDataStack.context)
////                let tuneArray = tunebook.tune?.array
////                tunebook.contentDescription = contentDescription
////                tunebook.title = title
////                print("Tune JSON contents: \(tuneJson)")
//            
//                //finished importing Tunebooks
//                //tunebook.tune = tuneArray
//                // lets see if we can use SwiftyJson to do this a bit nicer
//            
//            
//                    
//        }
//            
//            coreDataStack.saveContext()
//            //print("Imported \(jsonArray.count) Tunebooks")
//            
//        } catch let error as NSError {
//            print("Error importing Tunebook: \(error)")
//        }
//    }


func importJSONTuneSeedDataIfNeeded() {
    
    let fetchRequest = NSFetchRequest(entityName: "Tune")
    var error:NSError? = nil
    let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: &error)
    if count == 0 {
        importJSONTuneSeedData()
    }
    
}


func importJSONTuneSeedData() {
    //just a test function to import some data from the json file to give me some test data
    
    let jsonURL = NSBundle.mainBundle().URLForResource("seedTunes", withExtension: "json")
    let jsonData = NSData(contentsOfURL: jsonURL!)
    
    do {
        let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as! NSArray
        let entity = NSEntityDescription.entityForName("Tune", inManagedObjectContext: coreDataStack.context)
        
        for jsonDictionary in jsonArray {
            let tuneobj = Tune(entity: entity!, insertIntoManagedObjectContext: coreDataStack.context)
            tuneobj.abc = (jsonDictionary["abc"] as! String)
            tuneobj.comments = (jsonDictionary["comments"] as! String)
            tuneobj.composer = (jsonDictionary["composer"] as! String)
            tuneobj.importSource = (jsonDictionary["importSource"] as! String)
            tuneobj.learningFlag = jsonDictionary["learningFlag"] as? Bool
            tuneobj.timeSignature = (jsonDictionary["timeSignature"] as! String)
            tuneobj.title = (jsonDictionary["title"] as! String)
            tuneobj.tuneKey = (jsonDictionary["tuneKey"] as! String)
            tuneobj.tuneType = (jsonDictionary["tuneType"] as! String)
        }
        
        coreDataStack.saveContext()
        print("Imported \(jsonArray.count) Tunes")
        
    } catch let error as NSError {
        print("Error importing Tunes: \(error)")
    }
}
}

































