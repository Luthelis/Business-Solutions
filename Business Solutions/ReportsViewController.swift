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
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var adView: ADBannerView!
    @IBOutlet weak var financeButton: UIButton!
    @IBOutlet weak var assetButton: UIButton!
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet var displayMenu: MenuView!
    @IBOutlet weak var displayButton: UIBarButtonItem!
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createMenu()
        createDisplayMenu()
        adView.delegate = self
        canDisplayBannerAds = true
        adView.hidden = true
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "detectAutoRotation:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    // MARK: - Menu view functions
    
    func createMenu()
    {
        let menuRectangle = CGRectMake((view.frame.maxX - (financeButton.frame.width * 2)), (containerView.frame.minY), (financeButton.frame.size.width * 2), (financeButton.frame.size.height * 5))
        menuView.frame = menuRectangle
        self.view.addSubview(menuView)
        menuView.hidden = true
    }
    
    func createDisplayMenu()
    {
        let menuRectangle = CGRectMake(containerView.frame.minX, containerView.frame.minY, (financeButton.frame.size.width * 2), (financeButton.frame.size.height * 5))
        displayMenu.frame = menuRectangle
        self.view.addSubview(displayMenu)
        displayMenu.hidden = true
    }
    
    @IBAction func showMenu(sender: UIBarButtonItem)
    {
        switch menuView.hidden
        {
        case true:
            menuView.hidden = false
        case false:
            menuView.hidden = true
        }
    }
    
    @IBAction func showDisplayMenu(sender: UIBarButtonItem)
    {
        switch displayMenu.hidden
        {
        case true:
            displayMenu.hidden = false
        case false:
            displayMenu.hidden = true
        }
    }
    
    
    @IBAction func selectInformationToShow(sender: UIButton)
    {
        displayButton.title = sender.titleLabel?.text
        let table = self.childViewControllers.first as! ReportsTableViewController
        table.configureFetchedResultsController(withEntityName: (sender.titleLabel?.text)!)
        displayMenu.hidden = true
    }
    
    // MARK: - Notification Center
    
    func detectAutoRotation(notification: NSNotification)
    {
        let menuTest = menuView.hidden
        let displayMenuTest = displayMenu.hidden
        createMenu()
        createDisplayMenu()
        switch menuTest
        {
        case true:
            menuView.hidden = true
        case false:
            menuView.hidden = false
        }
        switch displayMenuTest
        {
        case true:
            displayMenu.hidden = true
        case false:
            displayMenu.hidden = false
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addData"
        {
            if let destination = segue.destinationViewController as? AddDataViewController
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
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue)
    {
        let source = segue.sourceViewController as! AddDataViewController
        source.saveData()
        source.removeKeyboard()
        let child = self.childViewControllers.last as! ReportsTableViewController
        child.performFetches()
        child.tableView.reloadData()
    }
    
    @IBAction func prepareForUnwindWithCancel(segue : UIStoryboardSegue)
    {
        let source = segue.sourceViewController as! AddDataViewController
        source.removeKeyboard()
        let child = self.childViewControllers.last as! ReportsTableViewController
        child.performFetches()
        child.tableView.reloadData()
    }
    
    // MARK: - Handle Autorotation
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        let device = UIDevice()
        var orientation = UIInterfaceOrientationMask()
        switch device.userInterfaceIdiom
        {
        case .Phone:
            orientation = .AllButUpsideDown
        case .Pad:
            orientation = .All
        case .Unspecified: break
        default: break
        }
        return orientation
    }
}

extension ReportsViewController :ADBannerViewDelegate
{
    // MARK: - iAd delegate functions
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool
    {
        return true
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!)
    {
        banner.hidden = true
        let adDelay : NSTimeInterval = 60
        let timerDate = NSDate(timeIntervalSinceNow: adDelay)
        _ = NSTimer(fireDate: timerDate, interval: adDelay, target: self, selector: "restoreAdBannerPresence", userInfo: nil, repeats: false)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
    {
        banner.hidden = true
    }
    
    func restoreAdBannerPresence()
    {
        adView.hidden = false
    }

}