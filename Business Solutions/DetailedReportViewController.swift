//
//  DetailedReportViewController.swift
//  Business Solutions
//
//  Created by Timothy Transue on 10/29/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit
import CoreData

class DetailedReportViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Data Objects

    var fullItem : NSManagedObject!
    var context : NSManagedObjectContext!
    var resultsController : NSFetchedResultsController!
    let handler = CoreDataHandler()
    
    // MARK: - View Properties
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editAndDone: UIBarButtonItem!
    @IBOutlet weak var dataScroller: UIScrollView!
    @IBOutlet var financeView: UIView!
    @IBOutlet var assetView: UIView!
    @IBOutlet var vehicleView: UIView!
    @IBOutlet var accessoryView: UIView!
    
    // MARK: - Finance Properties
    
    @IBOutlet weak var financeDescription: UITextField!
    @IBOutlet weak var financeAmount: UITextField!
    @IBOutlet weak var financeDate: UITextField!
    @IBOutlet weak var financeRecurring: UISwitch!
    @IBOutlet weak var financeFrequency: UITextField!
    @IBOutlet var financeTextFieldCollection: [UITextField]!
    @IBOutlet weak var financeFrequencyLabel: UILabel!
    
    // MARK: - Asset Properties
    
    @IBOutlet weak var assetName: UITextField!
    @IBOutlet weak var assetSerialNumber: UITextField!
    @IBOutlet weak var assetPurchasePrice: UITextField!
    @IBOutlet weak var assetPurchaseDate: UITextField!
    @IBOutlet weak var assetRepairable: UISwitch!
    @IBOutlet weak var assetMaintenanceName: UITextField!
    @IBOutlet weak var assetMaintenanceCost: UITextField!
    @IBOutlet weak var assetMaintenanceDate: UITextField!
    @IBOutlet var assetTextFieldCollection: [UITextField]!
    @IBOutlet var assetMaintenanceTextFieldCollection: [UITextField]!
    @IBOutlet var assetMaintenanceLabelCollection: [UILabel]!
    
    // MARK: - Vehicle Properties
    
    @IBOutlet weak var vehicleName: UITextField!
    @IBOutlet weak var vehicleVIN: UITextField!
    @IBOutlet weak var vehicleYear: UITextField!
    @IBOutlet weak var vehicleMake: UITextField!
    @IBOutlet weak var vehicleModel: UITextField!
    @IBOutlet weak var vehiclePurchasePrice: UITextField!
    @IBOutlet weak var vehiclePurchaseDate: UITextField!
    @IBOutlet weak var vehiclePurchaseOdometer: UITextField!
    @IBOutlet weak var vehicleMaintenanceType: UITextField!
    @IBOutlet weak var vehicleMaintenancDate: UITextField!
    @IBOutlet weak var vehicleMaintenanceCost: UITextField!
    @IBOutlet weak var vehicleMaintenanceOdometerReading: UITextField!
    @IBOutlet var vehicleTextFieldCollection: [UITextField]!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        context = fullItem.managedObjectContext
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
        if fullItem.entity.name == "Finances"
        {
            dataScroller.addSubview(financeView)
            self.financeTextFieldCollection = orderTextFields(self.financeTextFieldCollection)
            restoreFinanceData()
        }
        else if fullItem.entity.name == "Assets"
        {
            dataScroller.addSubview(self.assetView)
            self.assetTextFieldCollection = orderTextFields(self.assetTextFieldCollection)
            restoreAssetData()
        }
        else if fullItem.entity.name == "Vehicles"
        {
            dataScroller.addSubview(self.vehicleView)
            self.vehicleTextFieldCollection = orderTextFields(self.vehicleTextFieldCollection)
            restoreVehicleData()
        }
        cancelButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func orderTextFields(fieldCollection: [UITextField]) -> [UITextField]
    {
        let sortedFieldCollection = fieldCollection.sort({ $0.tag < $1.tag})
        return sortedFieldCollection
    }

    // MARK: - Toolbar Items

    @IBAction func beginAndEndEditing(sender: UIBarButtonItem)
    {
        if sender.title == "Edit"
        {
            cancelButton.enabled = true
            sender.style = .Done
            sender.title = "Done"
            if self.dataScroller.subviews.first == self.financeView
            {
                for view in financeTextFieldCollection
                {
                    view.enabled = true
                }
                financeRecurring.enabled = true
            }
            else if self.dataScroller.subviews.first == self.assetView
            {
                for view in assetTextFieldCollection
                {
                    view.enabled = true
                }
                assetRepairable.enabled = true
            }
            else if self.dataScroller.subviews.first == self.vehicleView
            {
                for view in vehicleTextFieldCollection
                {
                    view.enabled = true
                }
            }
        }
        else if sender.title == "Done"
        {
            sender.title = "Edit"
            sender.style = .Plain
            cancelButton.enabled = false
            if self.dataScroller.subviews.first == self.financeView
            {
                for view in financeTextFieldCollection
                {
                    view.enabled = false
                }
                financeRecurring.enabled = false
            }
            else if self.dataScroller.subviews.first == self.assetView
            {
                for view in assetTextFieldCollection
                {
                    view.enabled = false
                }
                assetRepairable.enabled = false
            }
            else if self.dataScroller.subviews.first == self.vehicleView
            {
                for view in vehicleTextFieldCollection
                {
                    view.enabled = false
                }
            }
            saveData()
        }
        
    }
    @IBAction func cancelEditing(sender: UIBarButtonItem)
    {
        editAndDone.title = "Edit"
        editAndDone.style = .Plain
        sender.enabled = false
        if self.dataScroller.subviews.first == self.financeView
        {
            restoreFinanceData()
        }
        else if self.dataScroller.subviews.first == self.assetView
        {
            restoreAssetData()
        }
        else if self.dataScroller.subviews.first == self.vehicleView
        {
            restoreVehicleData()
        }
    }
    
    @IBAction func changeView(sender: UISwitch)
    {
        if sender.superview == self.financeView
        {
            if sender.on
            {
                self.financeFrequencyLabel.hidden = false
                self.financeFrequency.hidden = false
            }
            else
            {
                self.financeFrequency.hidden = true
                self.financeFrequencyLabel.hidden = true
            }
        }
        else if sender.superview == self.assetView
        {
            if sender.on
            {
                for view in assetMaintenanceLabelCollection
                {
                    view.hidden = false
                }
                for view in assetMaintenanceTextFieldCollection
                {
                    view.hidden = false
                }
            }
            else
            {
                for view in assetMaintenanceLabelCollection
                {
                    view.hidden = true
                }
                for view in assetMaintenanceTextFieldCollection
                {
                    view.hidden = true
                }
            }
        }
    }
    func restoreFinanceData()
    {
        let financeObject = fullItem as! Finances
        financeDescription.text = financeObject.name
        financeAmount.text = "\(financeObject.amount!)"
        financeDate.text = parseDateInformation(financeObject.date!)
        if (financeObject.recurring?.boolValue)! == 0
        {
            financeRecurring.setOn(false, animated: false)
            financeFrequency.hidden = true
            financeFrequencyLabel.hidden = true
        }
        else
        {
            financeRecurring.setOn(true, animated: false)
            financeFrequency.text = financeObject.frequency
        }
    }
    
    func restoreAssetData()
    {
        let assetObject = fullItem as! Assets
        assetName.text = assetObject.nameOfItem
        assetSerialNumber.text = assetObject.serialNumber
        assetPurchasePrice.text = "$\(assetObject.cost!)"
        assetPurchaseDate.text = "\(assetObject.dateOfPurchase!)"
        if (assetObject.maintainable?.boolValue)! == 0
        {
            for label in assetMaintenanceLabelCollection
            {
                label.hidden = true
            }
            for field in assetMaintenanceTextFieldCollection
            {
                field.hidden = true
            }
            assetRepairable.setOn(false, animated: false)
        }
        else
        {
            assetMaintenanceName.text = assetObject.maintenanceDescription
            assetMaintenanceCost.text = "$\(assetObject.maintenanceCost!)"
            assetMaintenanceDate.text = "\(assetObject.maintenanceDate!)"
            assetRepairable.setOn(true, animated: false)
        }
    }
    
    func restoreVehicleData()
    {
        let vehicleObject = fullItem as! Vehicles
        vehicleName.text = vehicleObject.vehicleName
        vehicleVIN.text = vehicleObject.vin
        vehicleYear.text = "\(vehicleObject.year!)"
        vehicleMake.text = vehicleObject.make
        vehicleModel.text = vehicleObject.model
        vehiclePurchasePrice.text = "$\(vehicleObject.purchaseCost!)"
        vehiclePurchaseDate.text = "\(vehicleObject.dateOfPurchase!)"
        vehiclePurchaseOdometer.text = "\(vehicleObject.initialOdometer!)"
        vehicleMaintenanceType.text = vehicleObject.maintenanceType
        vehicleMaintenancDate.text = "\(vehicleObject.dateOfMaintenance)"
        vehicleMaintenanceCost.text = "\(vehicleObject.maintenanceCost)"
        vehicleMaintenanceOdometerReading.text = "\(vehicleObject.maintenanceOdometer)"
    }
    
    func parseDateInformation(date : NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter.stringFromDate(date)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Autorotation Detection
    
    func detectAutoRotation(notification: NSNotification)
    {
        dataScroller.subviews.first!.setNeedsDisplay()
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
        if self.fullItem.entity == "Finances"
        {
            for field in self.financeTextFieldCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            textArray.insert("\(financeRecurring.on)", atIndex: textArray.endIndex)
            self.handler.editManagedObject(fullItem, withTextData: textArray)
        }
        else if self.fullItem.entity == "Assets"
        {
            for field in self.assetTextFieldCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            textArray.insert("\(assetRepairable.on)", atIndex: textArray.endIndex)
            self.handler.editManagedObject(fullItem, withTextData: textArray)
        }
        else if self.fullItem.entity == "Vehicles"
        {
            for field in self.vehicleTextFieldCollection
            {
                textArray.insert(field.text!, atIndex: textArray.endIndex)
            }
            self.handler.editManagedObject(fullItem, withTextData: textArray)
        }
    }
    
    // MARK: - Notification Center Functions
    
    func keyboardWillShow(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        let localKeyboard = (userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber).boolValue
        if localKeyboard
        {
            let keyboardSize = (userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            dataScroller.contentInset = contentInsets
            if dataScroller.subviews.first == financeView
            {
                let firstResponderTextField = self.detectFirstResponder(inView: financeView) as! UITextField
                let tagToQuery = firstResponderTextField.tag
                if tagToQuery == 3
                {
                    let datePicker = UIDatePicker(frame: keyboardSize)
                    datePicker.datePickerMode = .Date
                    datePicker.setDate(NSDate(), animated: false)
                    datePicker.addTarget(self, action: "updateDateField:", forControlEvents: .ValueChanged)
                    firstResponderTextField.inputView = datePicker
                }
                else if tagToQuery == 4
                {
                    let recurringPicker = UIPickerView(frame: keyboardSize)
                    recurringPicker.delegate = self
                    recurringPicker.dataSource = self
                    firstResponderTextField.inputView = recurringPicker
                }
            }
            else if dataScroller.subviews.first == vehicleView
            {
                let firstResponderTextField = self.detectFirstResponder(inView: vehicleView) as! UITextField
                let tagToQuery = firstResponderTextField.tag
                if tagToQuery == 1
                {
                    let vehiclePicker = UIPickerView(frame: keyboardSize)
                    vehiclePicker.delegate = self
                    vehiclePicker.dataSource = self
                    firstResponderTextField.inputView = vehiclePicker
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        dataScroller.contentInset = contentInsets
        dataScroller.contentOffset = CGPointZero
    }
    
    // MARK: - Accessory View Functions
    
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
    
    @IBAction func dismissKeyboard(sender: UIButton)
    {
        if let field = detectFirstResponder(inView: dataScroller.subviews.first!) as? UITextField
        {
            field.resignFirstResponder()
        }
    }
    
    func removeKeyboard()
    {
        if let field = detectFirstResponder(inView: dataScroller.subviews.first!) as? UITextField
        {
            field.resignFirstResponder()
        }
    }
}

// MARK: - Text Field Delegate Functions

extension DetailedReportViewController: UITextFieldDelegate
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

// MARK: - Picker Functions

extension DetailedReportViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        if pickerView.superview == self.financeView
        {
            return 1
        }
        else if pickerView.superview == self.vehicleView
        {
            return (resultsController.sections?.count)!
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.superview == self.financeView
        {
            return 8
        }
        else if pickerView.superview == self.vehicleView
        {
            if resultsController.fetchRequest.entityName == "Vehicles"
            {
                return (resultsController.fetchedObjects?.count)! + 1
            }
            return 0
        }
        else
        {
            return 0
        }
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
                let vehicle = resultsController?.objectAtIndexPath(indexPath) as! Vehicles
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
                let object = resultsController?.objectAtIndexPath(indexPath) as! Vehicles
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
