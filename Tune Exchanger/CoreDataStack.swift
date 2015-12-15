//
//  CoreDataStack.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 07/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    let modelName = "Tunebook"
    
    private lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]}()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        do {
        let options = [NSMigratePersistentStoresAutomaticallyOption : true]
        try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
    } catch {
        print("Error adding persistent store.")
        }
        return coordinator
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle()
        .URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    func saveContext () {
        if context.hasChanges {
        do {
            try context.save()
        } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
        
}