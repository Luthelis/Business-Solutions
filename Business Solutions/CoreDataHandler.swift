//
//  CoreDataHandler.swift
//  Business Solutions
//
//  Created by Timothy Transue on 9/2/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler
{
    var context: NSManagedObjectContext
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init()
    {
        context = appDelegate.managedObjectContext
    }
    
    func createManagedObject(withData textInfo : [String], withEntityName name : String)
    {
        if name == "Finances"
        {
            let financeManagedObject = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! Finances
            editManagedObject(financeManagedObject, withTextData: textInfo)
        }
        else if name == "Assets"
        {
            let assetManagedObject = NSEntityDescription.insertNewObjectForEntityForName(name,inManagedObjectContext: context) as! Assets
            editManagedObject(assetManagedObject, withTextData: textInfo)
        }
        else if name == "Vehicles"
        {
            let vehicleManagedObject = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! Vehicles
            editManagedObject(vehicleManagedObject, withTextData: textInfo)
        }
    }
    
    func editManagedObject(object:NSManagedObject, withTextData info:[String])
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        if object.entity.name == "Finances"
        {
            var financeData = info
            let financeManagedObject = object as! Finances
            financeManagedObject.name = financeData.first
            financeData.removeFirst()
            financeManagedObject.amount = NSNumberFormatter().numberFromString(financeData.first!)
            financeData.removeFirst()
            financeManagedObject.date = formatter.dateFromString(financeData.first!)
            financeData.removeFirst()
            financeManagedObject.frequency = financeData.first
            financeData.removeFirst()
            financeManagedObject.recurring = NSNumberFormatter().numberFromString(financeData.first!)
            financeData.removeFirst()
        }
        else if object.entity.name == "Assets"
        {
            var assetInfo = info
            let assetManagedObject = object as! Assets
            assetManagedObject.nameOfItem = assetInfo.first
            assetInfo.removeFirst()
            assetManagedObject.serialNumber = assetInfo.first
            assetInfo.removeFirst()
            assetManagedObject.cost = NSNumberFormatter().numberFromString(assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.dateOfPurchase = formatter.dateFromString(assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintenanceDescription = assetInfo.first
            assetInfo.removeFirst()
            assetManagedObject.maintenanceCost = NSNumberFormatter().numberFromString(assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintenanceDate = formatter.dateFromString(assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintainable = NSNumberFormatter().numberFromString(assetInfo.first!)
            assetInfo.removeFirst()
        }
        else if object.entity.name == "Vehicles"
        {
            var vehicleInfo = info
            let vehicleManagedObject = object as! Vehicles
            vehicleManagedObject.vehicleName = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.vin = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.year = NSNumberFormatter().numberFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.make = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.model = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.purchaseCost = NSNumberFormatter().numberFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.dateOfPurchase = formatter.dateFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.initialOdometer = NSNumberFormatter().numberFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceType = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.dateOfMaintenance = formatter.dateFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceCost = NSNumberFormatter().numberFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceOdometer = NSNumberFormatter().numberFromString(vehicleInfo.first!)
            vehicleInfo.removeFirst()
        }
        appDelegate.saveContext()
    }
    
    func deleteManagedObject(object:NSManagedObject)
    {
        do
        {
            try object.validateForDelete()
            context.deleteObject(object)
            appDelegate.saveContext()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func createFetchRequest(forEntityName entity:String) -> NSFetchRequest
    {
        let request = NSFetchRequest(entityName: entity)
        var sorter : NSSortDescriptor
        if request.entityName == "Finances"
        {
            sorter = NSSortDescriptor(key: "date", ascending:true)
            request.sortDescriptors = [sorter]
        }
        else if request.entityName == "Assets"
        {
            sorter = NSSortDescriptor(key: "dateOfPurchase", ascending: true)
            request.sortDescriptors = [sorter]
        }
        else if request.entityName == "Vehicles"
        {
            sorter = NSSortDescriptor(key: "dateOfPurchase", ascending: true)
            request.sortDescriptors = [sorter]
        }
        return request
    }
    
}
