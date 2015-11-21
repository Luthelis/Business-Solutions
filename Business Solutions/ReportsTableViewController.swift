//
//  ReportsTableViewController.swift
//  Business Solutions
//
//  Created by Timothy Transue on 10/25/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit
import CoreData

class ReportsTableViewController: UITableViewController {

    let financeController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Finances"), managedObjectContext: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    let assetController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Assets"), managedObjectContext: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    let vehicleController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Vehicles"), managedObjectContext: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    var designatedController : NSFetchedResultsController?
    let handler = CoreDataHandler()
    let calendar = NSCalendar.autoupdatingCurrentCalendar()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        designatedController = financeController
        self.performFetches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return (designatedController!.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (designatedController!.fetchedObjects?.count)!
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath)
    {
        let newCell = cell as! BusinessCell
        if designatedController == financeController
        {
            let finances = financeController.objectAtIndexPath(indexPath) as! Finances
            newCell.titleLabel.text = finances.name
            newCell.amountLabel.text = "$\(finances.amount!)"
        }
        else if designatedController == assetController
        {
            let assets = assetController.objectAtIndexPath(indexPath) as! Assets
            if assets.maintainable?.boolValue == true
            {
                newCell.titleLabel.text = assets.nameOfItem! + " " + assets.maintenanceDescription!
                newCell.amountLabel.text = "$\(assets.maintenanceCost!)"
            }
            else
            {
                newCell.titleLabel.text = assets.nameOfItem
                newCell.amountLabel.text = "$\(assets.cost!)"
            }
        }
        else if designatedController == vehicleController
        {
            let vehicle = vehicleController.objectAtIndexPath(indexPath) as! Vehicles
            if vehicle.maintenanceType == ""
            {
                newCell.titleLabel.text = vehicle.vehicleName
                newCell.amountLabel.text = "\(vehicle.purchaseCost!)"
            }
            else
            {
                newCell.titleLabel.text = vehicle.vehicleName! + " " + vehicle.maintenanceType!
                newCell.amountLabel.text = "$\(vehicle.maintenanceCost!)"
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath: indexPath) as! BusinessCell
        // Configure the cell...
        if designatedController == financeController
        {
            let finances = financeController.objectAtIndexPath(indexPath) as! Finances
            cell.titleLabel.text = finances.name
            cell.amountLabel.text = "$\(finances.amount!)"
        }
        else if designatedController == assetController
        {
            let assets = assetController.objectAtIndexPath(indexPath) as! Assets
            if assets.maintainable?.boolValue == true
            {
                cell.titleLabel.text = assets.nameOfItem! + " " + assets.maintenanceDescription!
                cell.amountLabel.text = "$\(assets.maintenanceCost!)"
            }
            else
            {
                cell.titleLabel.text = assets.nameOfItem
                cell.amountLabel.text = "$\(assets.cost!)"
            }
        }
        else if designatedController == vehicleController
        {
            let vehicle = vehicleController.objectAtIndexPath(indexPath) as! Vehicles
            if vehicle.maintenanceType == ""
            {
                cell.titleLabel.text = vehicle.vehicleName
                cell.amountLabel.text = "$\(vehicle.purchaseCost!)"
            }
            else
            {
                cell.titleLabel.text = vehicle.vehicleName! + " " + vehicle.maintenanceType!
                cell.amountLabel.text = "$\(vehicle.maintenanceCost!)"
            }
        }

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if designatedController == financeController
            {
                let finance = financeController.objectAtIndexPath(indexPath)
                context.delete(finance)
            }
            else if designatedController == assetController
            {
                let asset = assetController.objectAtIndexPath(indexPath)
                context.delete(asset)
            }
            else if designatedController == vehicleController
            {
                let vehicle = vehicleController.objectAtIndexPath(indexPath)
                context.delete(vehicle)
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        }
        else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMoreInformation"
        {
            let destination = segue.destinationViewController as! DetailedReportViewController
            if designatedController == financeController
            {
                let managedObject = financeController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Finances
                destination.fullItem = managedObject
            }
            else if designatedController == assetController
            {
                let managedObject = assetController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Assets
                destination.fullItem = managedObject
            }
            else if designatedController == vehicleController
            {
                let managedObject = vehicleController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Vehicles
                destination.fullItem = managedObject
            }

        }
    }
    
    @IBAction func prepareForUnwindWithDelete(segue: UIStoryboardSegue)
    {
        let source = segue.sourceViewController as! DetailedReportViewController
        let destination = segue.destinationViewController as! ReportsTableViewController
        handler.deleteManagedObject(source.fullItem)
        destination.tableView.reloadData()
    }
}

// MARK: - Extension for NSFetchedResultsController Delegate

extension ReportsTableViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        switch type
        {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch type
        {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.endUpdates()
    }
    
    func configureFetchedResultsController(withEntityName name: String)
    {
        self.tableView.beginUpdates()
        if name == "Finances"
        {
            designatedController = financeController
        }
        else if name == "Assets"
        {
            designatedController = assetController
        }
        else if name == "Vehicles"
        {
            designatedController = vehicleController
        }
        self.performFetches()
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    func performFetches()
    {
        do {
            try designatedController!.performFetch()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
