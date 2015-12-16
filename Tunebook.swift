//
//  Tunebook.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 14/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Tunebook: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func importJSONTunebookFile(jsonFileUrl: NSURL, coreDataStack: CoreDataStack) -> Bool {
        //function to import to tunebook from a json file
        let TunebookEntity = NSEntityDescription.entityForName("Tunebook", inManagedObjectContext: coreDataStack.context)
        let TuneEntity = NSEntityDescription.entityForName("Tune", inManagedObjectContext: coreDataStack.context)
        let SetEntity = NSEntityDescription.entityForName("Set", inManagedObjectContext: coreDataStack.context)
        let json:JSON = JSON(data: NSData(contentsOfURL: jsonFileUrl)!)
        if let tunebookArray = json["tunebook"].array {  //get the tunebookArray
            for tunebook in tunebookArray {
                let tunebookData = Tunebook(entity: TunebookEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                tunebookData.title = tunebook["title"].string
                tunebookData.contentDescription = tunebook["contentDescription"].string
                print("title = \(tunebookData.title!), description = \(tunebookData.contentDescription!)")
                if let tunes = tunebook["tune"].array {
                    //import tune but link back to tunebook entry
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
            return true
        } //end of if let tunebook
    return false
    }
}
