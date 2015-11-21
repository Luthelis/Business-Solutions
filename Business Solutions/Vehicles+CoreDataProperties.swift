//
//  Vehicles+CoreDataProperties.swift
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

extension Vehicles {

    @NSManaged var dateOfMaintenance: NSDate?
    @NSManaged var dateOfPurchase: NSDate?
    @NSManaged var initialOdometer: NSNumber?
    @NSManaged var maintenanceCost: NSNumber?
    @NSManaged var maintenanceOdometer: NSNumber?
    @NSManaged var maintenanceType: String?
    @NSManaged var make: String?
    @NSManaged var model: String?
    @NSManaged var purchaseCost: NSNumber?
    @NSManaged var vehicleName: String?
    @NSManaged var vin: String?
    @NSManaged var year: NSNumber?

}
