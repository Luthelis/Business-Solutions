//
//  Assets+CoreDataProperties.swift
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

extension Assets {

    @NSManaged var cost: NSNumber?
    @NSManaged var dateOfPurchase: Date?
    @NSManaged var maintainable: NSNumber?
    @NSManaged var maintenanceCost: NSNumber?
    @NSManaged var maintenanceDate: Date?
    @NSManaged var maintenanceDescription: String?
    @NSManaged var nameOfItem: String?
    @NSManaged var serialNumber: String?

}
