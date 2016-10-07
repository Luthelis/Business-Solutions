//
//  Finances+CoreDataProperties.swift
//  Business Solutions
//
//  Created by Timothy Transue on 10/24/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Finances {

    @NSManaged var amount: NSNumber?
    @NSManaged var date: Date?
    @NSManaged var frequency: String?
    @NSManaged var name: String?
    @NSManaged var recurring: NSNumber?

}
