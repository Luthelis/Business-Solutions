//
//  ReportsViewController.swift
//  Business Solutions
//
//  Created by Timothy Transue on 7/13/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit
import AdSupport
import iAd


class ReportsViewController: UIViewController
{
    // MARK: - Variables
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var menuView: MenuView!
    @IBOutlet weak var financeButton: UIButton!
    @IBOutlet weak var assetButton: UIButton!
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet var displayMenu: MenuView!
    @IBOutlet weak var displayButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createMenu()
        createDisplayMenu()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ReportsViewController.detectAutoRotation(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var shouldAutorotate : Bool
    {
        return false
    }
    
    // MARK: - Menu view functions
    
    func createMenu()
    {
        let menuRectangle = CGRect(x: (containerView.frame.maxX - (financeButton.frame.width * 2)), y: (containerView.frame.minY), width: (financeButton.frame.size.width * 2), height: (financeButton.frame.size.height * 5))
        menuView.frame = menuRectangle
        self.view.addSubview(menuView)
        menuView.isHidden = true
    }
    
    func createDisplayMenu()
    {
        let menuRectangle = CGRect(x: containerView.frame.minX, y: containerView.frame.minY, width: (financeButton.frame.size.width * 2), height: (financeButton.frame.size.height * 5))
        displayMenu.frame = menuRectangle
        self.view.addSubview(displayMenu)
        displayMenu.isHidden = true
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem)
    {
        switch menuView.isHidden
        {
        case true:
            menuView.isHidden = false
        case false:
            menuView.isHidden = true
        }
    }
    
    @IBAction func showDisplayMenu(_ sender: UIBarButtonItem)
    {
        switch displayMenu.isHidden
        {
        case true:
            displayMenu.isHidden = false
        case false:
            displayMenu.isHidden = true
        }
    }
    
    
    @IBAction func selectInformationToShow(_ sender: UIButton)
    {
        displayButton.title = sender.titleLabel?.text
        let table = self.childViewControllers.first as! ReportsTableViewController
        table.configureFetchedResultsController(withEntityName: (sender.titleLabel?.text)!)
        displayMenu.isHidden = true
    }
    
    // MARK: - Notification Center
    
    func detectAutoRotation(_ notification: Notification)
    {
        let menuTest = menuView.isHidden
        let displayMenuTest = displayMenu.isHidden
        createMenu()
        createDisplayMenu()
        switch menuTest
        {
        case true:
            menuView.isHidden = true
        case false:
            menuView.isHidden = false
        }
        switch displayMenuTest
        {
        case true:
            displayMenu.isHidden = true
        case false:
            displayMenu.isHidden = false
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addData"
        {
            if let destination = segue.destination as? AddDataViewController
            {
                if let button = sender as? UIButton
                {
                    let child = self.childViewControllers.last as! ReportsTableViewController
                    destination.titleString = button.titleLabel?.text
                    if button.titleLabel?.text == "Finances"
                    {
                        destination.dataSelector = 1
                        destination.designatedController = child.financeController
                    }
                    else if button.titleLabel?.text == "Assets"
                    {
                        destination.dataSelector = 2
                        destination.designatedController = child.assetController
                    }
                    else if button.titleLabel?.text == "Vehicles"
                    {
                        destination.dataSelector = 3
                        destination.designatedController = child.vehicleController
                    }
                }
            }
        }
    }
    
    @IBAction func prepareForUnwind(_ segue : UIStoryboardSegue)
    {
        let source = segue.source as! AddDataViewController
        source.saveData()
        source.removeKeyboard()
        let child = self.childViewControllers.last as! ReportsTableViewController
        child.performFetches()
        child.tableView.reloadData()
    }
    
    @IBAction func prepareForUnwindWithCancel(_ segue : UIStoryboardSegue)
    {
        let source = segue.source as! AddDataViewController
        source.removeKeyboard()
        let child = self.childViewControllers.last as! ReportsTableViewController
        child.performFetches()
        child.tableView.reloadData()
    }
    
    // MARK: - Handle Autorotation
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        let device = UIDevice()
        var orientation = UIInterfaceOrientationMask()
        switch device.userInterfaceIdiom
        {
        case .phone:
            orientation = .allButUpsideDown
        case .pad:
            orientation = .all
        case .unspecified: break
        default: break
        }
        return orientation
    }
}

