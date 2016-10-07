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

    let financeController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Finances"), managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    let assetController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Assets"), managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    let vehicleController = NSFetchedResultsController(fetchRequest: CoreDataHandler().createFetchRequest(forEntityName: "Vehicles"), managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    var designatedController : NSFetchedResultsController<NSManagedObject>?
    let handler = CoreDataHandler()
    let calendar = Calendar.autoupdatingCurrent
    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return (designatedController!.sections?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (designatedController!.fetchedObjects?.count)!
    }

    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath)
    {
        let newCell = cell as! BusinessCell
        if designatedController == financeController
        {
            let finances = financeController.object(at: indexPath) as! Finances
            newCell.titleLabel.text = finances.name
            newCell.amountLabel.text = "$\(finances.amount!)"
        }
        else if designatedController == assetController
        {
            let assets = assetController.object(at: indexPath) as! Assets
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
            let vehicle = vehicleController.object(at: indexPath) as! Vehicles
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! BusinessCell
        // Configure the cell...
        if designatedController == financeController
        {
            let finances = financeController.object(at: indexPath) as! Finances
            cell.titleLabel.text = finances.name
            cell.amountLabel.text = "$\(finances.amount!)"
        }
        else if designatedController == assetController
        {
            let assets = assetController.object(at: indexPath) as! Assets
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
            let vehicle = vehicleController.object(at: indexPath) as! Vehicles
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let handler = CoreDataHandler()
            if designatedController == financeController
            {
                let finance = financeController.object(at: indexPath) as! Finances
                handler.deleteManagedObject(finance)
            }
            else if designatedController == assetController
            {
                let asset = assetController.object(at: indexPath) as! Assets
                handler.deleteManagedObject(asset)
            }
            else if designatedController == vehicleController
            {
                let vehicle = vehicleController.object(at: indexPath) as! Vehicles
                handler.deleteManagedObject(vehicle)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        else if editingStyle == .insert
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
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMoreInformation"
        {
            let destination = segue.destination as! DetailedReportViewController
            if designatedController == financeController
            {
                let managedObject = financeController.object(at: tableView.indexPathForSelectedRow!) as! Finances
                destination.fullItem = managedObject
            }
            else if designatedController == assetController
            {
                let managedObject = assetController.object(at: tableView.indexPathForSelectedRow!) as! Assets
                destination.fullItem = managedObject
            }
            else if designatedController == vehicleController
            {
                let managedObject = vehicleController.object(at: tableView.indexPathForSelectedRow!) as! Vehicles
                destination.fullItem = managedObject
            }

        }
    }
    
    @IBAction func prepareForUnwindWithDelete(_ segue: UIStoryboardSegue)
    {
        let source = segue.source as! DetailedReportViewController
        let destination = segue.destination as! ReportsTableViewController
        handler.deleteManagedObject(source.fullItem)
        destination.tableView.reloadData()
    }
}

// MARK: - Extension for NSFetchedResultsController Delegate

extension ReportsTableViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type
        {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            self.configureCell(self.tableView.cellForRow(at: indexPath!)!, indexPath: indexPath!)
        
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
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
