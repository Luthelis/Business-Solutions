//
//  AddDataViewController.swift
//  Business Solutions
//
//  Created by Timothy Transue on 7/26/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit
import CoreData

class AddDataViewController: UIViewController, UIScrollViewDelegate {
   
    // MARK: - Main View outlets
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var dataScroller: UIScrollView!
    
    // MARK: - Finance View outlets
    
    @IBOutlet var financeView: UIView!
    @IBOutlet weak var financeName: UITextField!
    @IBOutlet weak var financeAmount: UITextField!
    @IBOutlet weak var financeDate: UITextField!
    @IBOutlet weak var financeRecurring: UISwitch!
    @IBOutlet weak var financeFrequency: UITextField!
    @IBOutlet var financeCollection: [UITextField]!
    @IBOutlet var frequencyLabelCollection: [UILabel]!
    @IBOutlet var frequencyTextFieldCollection: [UITextField]!
    
    // MARK: - Asset View outlets
    
    @IBOutlet var assetView: UIView!
    @IBOutlet weak var assetName: UITextField!
    @IBOutlet weak var assetSerialNumber: UITextField!
    @IBOutlet weak var assetPrice: UITextField!
    @IBOutlet weak var assetPurchaseDate: UITextField!
    @IBOutlet weak var assetMaintainable: UISwitch!
    @IBOutlet weak var assetMaintenanceType: UITextField!
    @IBOutlet weak var assetMaintenancePrice: UITextField!
    @IBOutlet weak var assetMaintenanceDate: UITextField!
    @IBOutlet var assetCollection: [UITextField]!
    @IBOutlet var maintenanceLabelCollection: [UILabel]!
    @IBOutlet var maintenanceTextFieldCollection: [UITextField]!
   
    
    // MARK: - Vehicle View outlets
    
    @IBOutlet var vehicleView: UIView!
    @IBOutlet weak var vehicleName: UITextField!
    @IBOutlet weak var vehicleVIN: UITextField!
    @IBOutlet weak var vehicleYear: UITextField!
    @IBOutlet weak var vehicleMake: UITextField!
    @IBOutlet weak var vehicleModel: UITextField!
    @IBOutlet weak var vehiclePurchasePrice: UITextField!
    @IBOutlet weak var vehiclePurchaseDate: UITextField!
    @IBOutlet weak var vehiclePurchaseOdometer: UITextField!
    @IBOutlet weak var vehicleMaintenanceName: UITextField!
    @IBOutlet weak var vehicleMaintenanceCost: UITextField!
    @IBOutlet weak var vehicleMaintenanceDate: UITextField!
    @IBOutlet weak var vehicleMaintenanceOdometer: UITextField!
    @IBOutlet var vehicleCollection: [UITextField]!
    
    // MARK: - Accessory View for Keyboard
    
    @IBOutlet var accessoryView: UIView!
    
    // MARK: - Picker Controls
    
    lazy var datePicker = UIDatePicker()
    lazy var recurringPicker = UIPickerView()
    lazy var vehiclePicker = UIPickerView()
    
    // MARK: - Main View Control Parameters
    
    var titleString: String?
    var dataSelector: Int?
    
    // MARK: - Data Controllers
    
    let handler = CoreDataHandler()
    let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var designatedController : NSFetchedResultsController?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presentingViewController?.supportedInterfaceOrientations()
        let device = UIDevice()
        device.beginGeneratingDeviceOrientationNotifications()
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: self)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: self)
        center.addObserver(self, selector: "detectAutoRotation:", name: UIDeviceOrientationDidChangeNotification, object: self)
        dataScroller.scrollEnabled = true
        dataScroller.bounces = true
        dataScroller.alwaysBounceVertical = true
        dataScroller.delegate = self
        titleBar.title = titleString!
        datePicker.datePickerMode = .Date
        datePicker.setDate(NSDate(), animated: false)
        datePicker.addTarget(self, action: "updateDateField:", forControlEvents: .ValueChanged)
        recurringPicker.delegate = self
        recurringPicker.dataSource = self
        vehiclePicker.delegate = self
        vehiclePicker.dataSource = self
        financeDate.inputView = datePicker
        financeFrequency.inputView = recurringPicker
        assetPurchaseDate.inputView = datePicker
        assetMaintenanceDate.inputView = datePicker
        vehiclePurchaseDate.inputView = datePicker
        vehicleMaintenanceDate.inputView = datePicker
        if dataSelector == 1
        {
            createFinanceView()
        }
        else if dataSelector == 2
        {
            createAssetView()
        }
        else if dataSelector == 3
        {
            createVehicleView()
            if designatedController?.fetchRequest.entityName == "Vehicles"
            {
                do {
                    try designatedController?.performFetch()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        if device.orientation == .LandscapeLeft || device.orientation == .LandscapeRight
        {
            self.view.setNeedsDisplay()
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        for screen in self.dataScroller.subviews
        {
            let field = self.detectFirstResponder(inView: screen)
            field?.resignFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Placing Functions
    
    func createFinanceView()
    {
        financeView.frame = view.frame
        dataScroller.addSubview(financeView)
        dataScroller.contentSize = financeView.frame.size
        setTextFieldProperties(financeCollection)
        financeCollection = orderTextFields(financeCollection)
        financeRecurring.setOn(false, animated: false)
        for label in frequencyLabelCollection
        {
            label.hidden = true
        }
        for field in frequencyTextFieldCollection
        {
            field.hidden = true
        }
        financeView.setNeedsDisplay()
    }
    
    func createAssetView()
    {
        assetView.frame = view.frame
        dataScroller.addSubview(assetView)
        dataScroller.contentSize = assetView.frame.size
        setTextFieldProperties(assetCollection)
        assetCollection = orderTextFields(assetCollection)
        assetMaintainable.setOn(false, animated: false)
        for label in maintenanceLabelCollection
        {
            label.hidden = true
        }
        for field in maintenanceTextFieldCollection
        {
            field.hidden = true
        }
        assetView.setNeedsDisplay()
    }
    
    func createVehicleView()
    {
        vehicleView.frame = view.frame
        dataScroller.addSubview(vehicleView)
        dataScroller.contentSize = vehicleView.frame.size
        setTextFieldProperties(vehicleCollection)
        vehicleCollection = orderTextFields(vehicleCollection)
        vehicleView.setNeedsDisplay()
    }
    
    func setTextFieldProperties(fieldCollection: [UITextField])
    {
        for field in fieldCollection
        {
            field.clearButtonMode = .WhileEditing
            field.delegate = self
            field.adjustsFontSizeToFitWidth = true
            field.minimumFontSize = 6
            field.inputAccessoryView = accessoryView
        }
    }
    
    func orderTextFields(fieldCollection: [UITextField]) -> [UITextField]
    {
        let sortedFieldCollection = fieldCollection.sort({ $0.tag < $1.tag})
        return sortedFieldCollection
    }
    
    // MARK: - Accessory View Functions
    
    @IBAction func dismissKeyboard(sender: UIButton)
    {
        if let field = detectFirstResponder(inView: dataScroller.subviews.first!) as? UITextField
        {
            field.resignFirstResponder()
        }
    }
    
    @IBAction func nextField(sender: UIButton)
    {
        let currentView = dataScroller.subviews.first!
        if let field = detectFirstResponder(inView: currentView) as? UITextField
        {
            let nextFieldTag = field.tag + 1
            for view in currentView.subviews
            {
                if view.tag == nextFieldTag
                {
                    if view.hidden == false
                    {
                        view.becomeFirstResponder()
                    }
                }
            }
            field.resignFirstResponder()
        }
    }

    @IBAction func previousField(sender: UIButton)
    {
        let currentView = dataScroller.subviews.first!
        if let currentField = detectFirstResponder(inView: currentView) as? UITextField
        {
            let previousFieldTag = currentField.tag - 1
            for view in currentView.subviews
            {
                if view.tag == previousFieldTag
                {
                    if view.hidden == false
                    {
                        view.becomeFirstResponder()
                    }
                }
            }
            currentField.resignFirstResponder()
        }
    }
    
    func removeKeyboard()
    {
        if let field = detectFirstResponder(inView: dataScroller.subviews.first!) as? UITextField
        {
            field.resignFirstResponder()
        }
    }
    
    // MARK: - Keyboard Notification Functions
    
    func keyboardWillShow(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        let localKeyboard = (userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
        if !localKeyboard
        {
            if let keyboardSize = (userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                dataScroller.contentInset = contentInsets
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                dataScroller.contentInset = contentInsets
            }
        }
        dataScroller.contentOffset = CGPointZero
    }
    
    // MARK: - Switch Action Functions
    
    @IBAction func financeRecurringSwitch(sender: UISwitch)
    {
        switch sender.on
        {
        case true:
            for label in frequencyLabelCollection
            {
                label.hidden = false
            }
            for field in frequencyTextFieldCollection
            {
                field.hidden = false
            }
        case false:
            for label in frequencyLabelCollection
            {
                label.hidden = true
            }
            for field in frequencyTextFieldCollection
            {
                field.hidden = true
            }
        }
    }
    
    @IBAction func assetMaintenanceSwitch(sender: UISwitch)
    {
        switch sender.on
        {
        case true:
            for label in maintenanceLabelCollection
            {
                label.hidden = false
            }
            for field in maintenanceTextFieldCollection
            {
                field.hidden = false
            }
        case false:
            for label in maintenanceLabelCollection
            {
                label.hidden = true
            }
            for field in maintenanceTextFieldCollection
            {
                field.hidden = true
            }
        }
    }
    

    // MARK: - Autorotation Detection
    
    func detectAutoRotation(notification: NSNotification)
    {
        self.view.setNeedsDisplay()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        self.view.setNeedsDisplay()
    }
    
    // MARK: - Miscellaneous View Functions
    
    func detectFirstResponder(inView view : UIView) -> UIView?
    {
        var responderView = view
        if responderView.isFirstResponder()
        {
            return responderView
        }
        else
        {
            for subView in responderView.subviews
            {
                if subView.isFirstResponder()
                {
                    responderView = subView
                }
            }
            return responderView
        }
    }
    
    func saveData()
    {
        var textArray = [String]()
        if self.dataSelector == 1
        {
            for field in self.financeCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            textArray.insert("\(financeRecurring.on)", atIndex: textArray.endIndex)
            self.handler.createManagedObject(withData: textArray, withEntityName: "Finances")
        }
        else if self.dataSelector == 2
        {
            for field in self.assetCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            textArray.insert("\(assetMaintainable.on)", atIndex: textArray.endIndex)
            self.handler.createManagedObject(withData: textArray, withEntityName: "Assets")
            var secondaryArray = [String]()
            secondaryArray.append(assetName.text!)
            if assetMaintainable.on
            {
                secondaryArray.append(assetMaintenancePrice.text!)
                secondaryArray.append(assetMaintenanceDate.text!)
                secondaryArray.append("\(false)")
            }
            else
            {
                secondaryArray.append(assetPrice.text!)
                secondaryArray.append(assetPurchaseDate.text!)
                secondaryArray.append("\(false)")

            }
                self.handler.createManagedObject(withData: secondaryArray, withEntityName: "Finances")
        }
        else if self.dataSelector == 3
        {
            for field in self.vehicleCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            self.handler.createManagedObject(withData: textArray, withEntityName: "Vehicles")
            var secondaryArray = [String]()
            secondaryArray.append(vehicleName.text!)
            if vehicleMaintenanceName.text != ""
            {
                secondaryArray.append(vehicleMaintenanceCost.text!)
                secondaryArray.append(vehicleMaintenanceDate.text!)
                secondaryArray.append("\(false)")
            }
            else
            {
                secondaryArray.append(vehiclePurchasePrice.text!)
                secondaryArray.append(vehiclePurchaseDate.text!)
                secondaryArray.append("\(false)")
            }
            self.handler.createManagedObject(withData: secondaryArray, withEntityName: "Finances")
        }
        self.applicationDelegate.saveContext()
    }

    func updateDateField(datePicker: UIDatePicker)
    {
        let formatter = NSDateFormatter()
        formatter.calendar = NSCalendar.autoupdatingCurrentCalendar()
        formatter.dateStyle = .MediumStyle
        (self.detectFirstResponder(inView: dataScroller.subviews.first!) as! UITextField).text = formatter.stringFromDate(datePicker.date)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Text Field Delegate Functions

extension AddDataViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        dataScroller.scrollRectToVisible(textField.frame, animated: true)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let nextFieldTag = textField.tag + 1
        for view in (dataScroller.subviews.first?.subviews)!
        {
            if view.tag == nextFieldTag
            {
                view.becomeFirstResponder()
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Picker View Delegate and Data Source

extension AddDataViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        if pickerView.superview == financeView
        {
            return 1
        }
        else if pickerView.superview == vehicleView
        {
            return (designatedController?.sections?.count)!
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.superview == financeView
        {
            return 8
        }
        else if pickerView.superview == vehicleView
        {
            return (designatedController?.fetchedObjects?.count)! + 1
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.superview == financeView
        {
            if component == 0
            {
                if row == 0
                {
                    return "Weekly"
                }
                else if row == 1
                {
                    return "Biweekly"
                }
                else if row == 2
                {
                    return "Semi-monthly"
                }
                else if row == 3
                {
                    return "Monthly"
                }
                else if row == 4
                {
                    return "Bimonthly"
                }
                else if row == 5
                {
                    return "Quarterly"
                }
                else if row == 6
                {
                    return "Semi-annually"
                }
                else if row == 7
                {
                    return "Annually"
                }
            }
            return ""
        }
        else if pickerView.superview == vehicleView
        {
            if row == 0
            {
                return "-- Add a vehicle --"
            }
            else
            {
                let indexPath = NSIndexPath(forRow: (row + 1), inSection: component)
                let vehicle = designatedController?.objectAtIndexPath(indexPath) as! Vehicles
                return vehicle.vehicleName!
            }
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.superview == financeView
        {
            if component == 0
            {
                if row == 0
                {
                    self.financeFrequency.text = "Weekly"
                }
                else if row == 1
                {
                    self.financeFrequency.text = "Biweekly"
                }
                else if row == 2
                {
                    self.financeFrequency.text = "Semi-monthly"
                }
                else if row == 3
                {
                    self.financeFrequency.text = "Monthly"
                }
                else if row == 4
                {
                    self.financeFrequency.text = "Bimonthly"
                }
                else if row == 5
                {
                    self.financeFrequency.text = "Quarterly"
                }
                else if row == 6
                {
                    self.financeFrequency.text = "Semi-annually"
                }
                else if row == 7
                {
                    self.financeFrequency.text = "Annually"
                }
            }
        }
        else if pickerView.superview == vehicleView
        {
            if row != 0 && component == 0
            {
                let indexPath = NSIndexPath(forRow: (row + 1), inSection: component)
                let object = designatedController?.objectAtIndexPath(indexPath) as! Vehicles
                vehicleName.text = object.vehicleName
                vehicleVIN.text = object.vin
                vehicleYear.text = "\(object.year!)"
                vehicleMake.text = object.make
                vehicleModel.text = object.model
                vehiclePurchaseDate.text = "\(object.purchaseCost!)"
                vehiclePurchaseOdometer.text = "\(object.initialOdometer)"
                vehiclePurchasePrice.text = "\(object.purchaseCost)"
            }
        }
    }
}

