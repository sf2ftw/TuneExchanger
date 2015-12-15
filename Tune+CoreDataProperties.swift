//
//  Tune+CoreDataProperties.swift
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

extension Tune {

    @NSManaged var abc: String?
    @NSManaged var comments: String?
    @NSManaged var composer: String?
    @NSManaged var image: NSData?
    @NSManaged var importSource: String?
    @NSManaged var learningFlag: NSNumber?
    @NSManaged var timeSignature: String?
    @NSManaged var title: String?
    @NSManaged var tuneKey: String?
    @NSManaged var tuneType: String?
    @NSManaged var url: String?
    @NSManaged var settunes: Set?
    @NSManaged var tunebook: NSOrderedSet?

}
