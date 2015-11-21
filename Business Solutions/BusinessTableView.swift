//
//  BusinessTableView.swift
//  Business Solutions
//
//  Created by Timothy Transue on 7/25/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BusinessTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    override func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell?
    {
        let cell = BusinessCell()
        cell.prepareForReuse()
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = BusinessCell()
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell.titleLabel.text = "Sample"
                cell.amountLabel.text = "$0.00"
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}