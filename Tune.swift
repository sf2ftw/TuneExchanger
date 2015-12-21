//
//  Tune.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 14/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Tune: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func importJSONTuneFile(jsonFileUrl: NSURL, coreDataStack: CoreDataStack) -> Bool {
        //function to import to tunebook from a json file
        if let TuneEntity = NSEntityDescription.entityForName("Tune", inManagedObjectContext: coreDataStack.context)
        {
            let json:JSON = JSON(data: NSData(contentsOfURL: jsonFileUrl)!)
            if let tuneArray = json["tune"].array {  //get the tunebookArray
                for tune in tuneArray {
                    let tuneData = Tune(entity: TuneEntity, insertIntoManagedObjectContext: coreDataStack.context)
                    tuneData.abc = tune["abc"].string
                    tuneData.comments = tune["comments"].string
                    tuneData.composer = tune["composer"].string
                    tuneData.importSource = tune["importSource"].string
                    tuneData.learningFlag = tune["learningFlag"].bool
                    tuneData.timeSignature = tune["timeSignature"].string
                    tuneData.title = tune["title"].string
                    tuneData.tuneKey = tune["tuneKey"].string
                    tuneData.tuneType = tune["tuneType"].string
                    print("title = \(tuneData.title), tuneKey = \(tuneData.tuneKey!)")
                }//end for loop
            }//end of tunebook loop
            coreDataStack.saveContext()
            return true
        } else {
        return false
        }
    }
    
    class func deleteTune(tuneToDelete: Tune, managedContext: NSManagedObjectContext) -> Bool {
        //give it a tune and it deletes it, returns bool if succesful   
        managedContext.deleteObject(tuneToDelete)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print ("Count not save: \(error)")
            return false
        }
    }
    
}
    



