//
//  Set+CoreDataProperties.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 14/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Set {

    @NSManaged var comments: String?
    @NSManaged var learningFlag: NSNumber?
    @NSManaged var title: String?
    @NSManaged var settunes: NSOrderedSet?
    @NSManaged var tunebook: Tunebook?

}
