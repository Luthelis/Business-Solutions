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

class CoreDataHandler: NSObject, NSFetchRequestResult
{
    var context: NSManagedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init()
    {
        context = appDelegate.managedObjectContext
    }
    
    func createManagedObject(withData textInfo : [String], withEntityName name : String)
    {
        if name == "Finances"
        {
            let financeManagedObject = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Finances
            editManagedObject(financeManagedObject, withTextData: textInfo)
        }
        else if name == "Assets"
        {
            let assetManagedObject = NSEntityDescription.insertNewObject(forEntityName: name,into: context) as! Assets
            editManagedObject(assetManagedObject, withTextData: textInfo)
        }
        else if name == "Vehicles"
        {
            let vehicleManagedObject = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Vehicles
            editManagedObject(vehicleManagedObject, withTextData: textInfo)
        }
    }
    
    func editManagedObject(_ object:NSManagedObject, withTextData info:[String])
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if object.entity.name == "Finances"
        {
            var financeData = info
            let financeManagedObject = object as! Finances
            financeManagedObject.name = financeData.first
            financeData.removeFirst()
            financeManagedObject.amount = NumberFormatter().number(from: financeData.first!)
            financeData.removeFirst()
            financeManagedObject.date = formatter.date(from: financeData.first!)
            financeData.removeFirst()
            financeManagedObject.frequency = financeData.first
            financeData.removeFirst()
            financeManagedObject.recurring = NumberFormatter().number(from: financeData.first!)
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
            assetManagedObject.cost = NumberFormatter().number(from: assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.dateOfPurchase = formatter.date(from: assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintenanceDescription = assetInfo.first
            assetInfo.removeFirst()
            assetManagedObject.maintenanceCost = NumberFormatter().number(from: assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintenanceDate = formatter.date(from: assetInfo.first!)
            assetInfo.removeFirst()
            assetManagedObject.maintainable = NumberFormatter().number(from: assetInfo.first!)
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
            vehicleManagedObject.year = NumberFormatter().number(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.make = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.model = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.purchaseCost = NumberFormatter().number(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.dateOfPurchase = formatter.date(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.initialOdometer = NumberFormatter().number(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceType = vehicleInfo.first
            vehicleInfo.removeFirst()
            vehicleManagedObject.dateOfMaintenance = formatter.date(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceCost = NumberFormatter().number(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
            vehicleManagedObject.maintenanceOdometer = NumberFormatter().number(from: vehicleInfo.first!)
            vehicleInfo.removeFirst()
        }
        appDelegate.saveContext()
    }
    
    func deleteManagedObject(_ object:NSManagedObject)
    {
        do
        {
            try object.validateForDelete()
            context.delete(object)
            appDelegate.saveContext()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func createFetchRequest(forEntityName entity:String) -> NSFetchRequest<NSManagedObject>
    {
        let request : NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entity)
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
