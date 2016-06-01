//
//  VehicleDetailsViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum TextfieldType: Int {
    case None = 0
    case Year = 1
    case Make = 2
    case Model = 3
    case EngineSize = 4
    case Part = 5
}
private enum PickerType: Int {
    case YearPicker = 0
    case MakePicker = 1
    case ModelPicker = 2
    case EnginePicker = 3
}
class VehicleDetailsViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var engineSizeTextField: UITextField!
    @IBOutlet weak var partTextField: UITextField!
    @IBOutlet weak var submitResultButton: UIButton!
    
    
    private var photo: UIImage?
    private var selectedTextfieldFrame: CGRect = CGRectZero
    private var selectedTextfieldType: TextfieldType = .None
    private var keyboardHeight: CGFloat = 0
    
    // pickers by vehicle
    private var yearPickerView: UIPickerView!
    private var makePickerView: UIPickerView!
    private var modelPickerView: UIPickerView!
    private var enginePickerView: UIPickerView!
    
    private var years: [String] = []
    private var makes: [String] = []
    private var models: [String] = []
    private var engines: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set VC title and back button
        self.navigationItem.title = "Vehicle Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        self.setUpTextFields()
        
        //get years
        self.years = self.getYears()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpTextFields() {
        
        // keyBoard
        let textfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        textfieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressHideKeyboardButton(_:)))]
        
        // year textField
        
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.partTextField.attributedPlaceholder = NSAttributedString(string: "Part", attributes: attributesDictionary)
        self.yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributesDictionary)
        self.yearPickerView = UIPickerView()
        self.yearPickerView.showsSelectionIndicator = true
        self.yearPickerView.delegate = self
        self.yearPickerView.dataSource = self
        self.yearPickerView.tag = PickerType.YearPicker.rawValue
        self.yearTextField.inputView = self.yearPickerView
        
        let yearTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        yearTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(VehicleDetailsViewController.didPressYearTextFieldDone(_:)))]
        self.yearTextField.inputAccessoryView = yearTextFieldToolbar
        
        // make textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.makeTextField.attributedPlaceholder = NSAttributedString(string: "Make", attributes: attributesDictionary)
        self.makePickerView = UIPickerView()
        self.makePickerView.showsSelectionIndicator = true
        self.makePickerView.delegate = self
        self.makePickerView.dataSource = self
        self.makePickerView.tag = PickerType.MakePicker.rawValue
        self.makeTextField.inputView = self.makePickerView
        
        let makeTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        makeTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(VehicleDetailsViewController.didPressMakePickerViewDone(_:)))]
        self.makeTextField.inputAccessoryView = makeTextFieldToolbar
        
        // model textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.modelTextField.attributedPlaceholder = NSAttributedString(string: "Model", attributes: attributesDictionary)
        self.modelPickerView = UIPickerView()
        self.modelPickerView.showsSelectionIndicator = true
        self.modelPickerView.delegate = self
        self.modelPickerView.dataSource = self
        self.modelPickerView.tag = PickerType.ModelPicker.rawValue
        self.modelTextField.inputView = self.modelPickerView
        
        let modelTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        modelTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(VehicleDetailsViewController.didPressModelPickerViewDone(_:)))]
        self.modelTextField.inputAccessoryView = modelTextFieldToolbar
        

        // engine size textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.engineSizeTextField.attributedPlaceholder = NSAttributedString(string: "Engine", attributes: attributesDictionary)
        self.enginePickerView = UIPickerView()
        self.enginePickerView.showsSelectionIndicator = true
        self.enginePickerView.delegate = self
        self.enginePickerView.dataSource = self
        self.enginePickerView.tag = PickerType.EnginePicker.rawValue
        self.engineSizeTextField.inputView = self.enginePickerView
        
        let engineSizeTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        engineSizeTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(VehicleDetailsViewController.didPressEngineSizePickerViewDone(_:)))]
        self.engineSizeTextField.inputAccessoryView = engineSizeTextFieldToolbar
        
        self.submitResultButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    private func getYears() -> [String] {
        var years = [String]()
        let todayDate = NSDate()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let currentYear = calendar.components(.Year, fromDate: todayDate)
        
        for var i = 1953; i <= currentYear.year; i += 1 {
            years.append(String(i))
        }
        years.sortInPlace(>)
        years.insert("Year", atIndex: 0)
        //        self.yearTextField.text = "2016"
        
        // get default makes
        
        if "" != self.yearTextField.text &&  4 <= self.yearTextField.text?.characters.count {
            
            if 0 != makes.count {
                self.makes.removeAll()
            }
            
            Network.sharedInstance.getMakeFromYear(self.yearTextField.text!) { (data) -> Void in
                
                if (nil != data) {
                    debugPrint("\(data)")
                    self.makes = data!
                    self.yearTextField.resignFirstResponder()
                } else {
                    CommonUtils.showAlert("Error", message: "Please correct searched fields")
                }
            }
        }
        
        return years
    }
    
    // MARK: - IBActions
    
    @IBAction func didPressSubmitButton(sender: UIButton) {
        if "" == self.yearTextField.text && "Year" == self.yearTextField.text{
            self.showNotificationAlertWithTitle("Please enter Year", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                self.yearTextField.becomeFirstResponder()
            })
        } else if "" == self.makeTextField.text && "Make" == self.makeTextField.text {
            self.showNotificationAlertWithTitle("Please enter Make", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                self.makeTextField.becomeFirstResponder()
            })
        } else if "" == self.modelTextField.text && "Model" == self.modelTextField.text {
            self.showNotificationAlertWithTitle("Please enter Model", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                self.modelTextField.becomeFirstResponder()
            })
        } else if "" == self.partTextField.text {
            self.showNotificationAlertWithTitle("Please enter Part", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                self.partTextField.becomeFirstResponder()
            })
        } else {
            let year = self.yearTextField.text as String!
            let make = self.makeTextField.text as String!
            let model = self.modelTextField.text as String!
            var engineSize: String = ""
            if let engineSizeString = self.engineSizeTextField.text{
                engineSize = engineSizeString
            }
            if engineSize == "Engine"{
                engineSize = ""
            }
            let part = self.partTextField.text as String!
            CommonUtils.showProgress(self.view, label: "Reading data...")
            Network.sharedInstance.getRepairs(year!, make: make!, model: model!, engineSize: engineSize, part: part!, completion: { (lowPrice, averagePrice, highPrice) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    CommonUtils.hideProgress()
                })
                if ("" != lowPrice && "" != averagePrice && "" != highPrice) {
                    let repairDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("repairDetailsViewController") as! RepairDetailsViewController!
                    repairDetailsViewController.lowPrice = lowPrice as String!
                    repairDetailsViewController.averagePrice = averagePrice as String!
                    repairDetailsViewController.highPrice = highPrice as String!
                    repairDetailsViewController.repairName = self.partTextField.text!
                    self.navigationController?.pushViewController(repairDetailsViewController, animated: true)
                } else {
                    CommonUtils.showAlert("Error", message: "There's no data you require in database.")
                    return
                }
            })
        }
    }
    
    func didPressYearTextFieldDone(sender: UIBarButtonItem) {
        self.yearTextField.resignFirstResponder()
    }
    
    func didPressMakePickerViewDone(sender: UIBarButtonItem) {
        self.makeTextField.resignFirstResponder()
    }
    
    func didPressModelPickerViewDone(sender: UIBarButtonItem) {
        self.modelTextField.resignFirstResponder()
    }
    
    func didPressEngineSizePickerViewDone(sender: UIBarButtonItem) {
        self.engineSizeTextField.resignFirstResponder()
    }
    
    //MARK: - UIPickerViewDataSource and UIPickerViewDelegate Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var returnValue = 0
        
        switch(pickerView.tag) {
            
        case PickerType.YearPicker.rawValue:
            returnValue = self.years.count
        case PickerType.MakePicker.rawValue:
            returnValue = self.makes.count
        case PickerType.ModelPicker.rawValue:
            returnValue = self.models.count
        case PickerType.EnginePicker.rawValue:
            returnValue = self.engines.count
        default:
            returnValue = 0
        }
        
        return returnValue
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var returnValue: String = ""
        
        switch(pickerView.tag) {
            
        case PickerType.YearPicker.rawValue:
            returnValue = self.years[row]
        case PickerType.MakePicker.rawValue:
            if 0 != self.makes.count {
                returnValue = self.makes[row]
            }
            
        case PickerType.ModelPicker.rawValue:
            if 0 != self.models.count {
                returnValue = self.models[row]
            }
        case PickerType.EnginePicker.rawValue:
            if 0 != self.engines.count {
                returnValue = self.engines[row]
            }
        default:
            returnValue = ""
        }
        
        return returnValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView.tag) {
            
        case PickerType.YearPicker.rawValue:
            self.yearTextField.text = self.years[row]
        case PickerType.MakePicker.rawValue:
            if 0 != self.makes.count {
                self.makeTextField.text = self.makes[row]
            }
        case PickerType.ModelPicker.rawValue:
            
            if 0 != self.models.count {
                self.modelTextField.text = self.models[row]
            }
        case PickerType.EnginePicker.rawValue:
            
            if 0 != self.engines.count {
                self.engineSizeTextField.text = self.engines[row]
            }
        default:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        var fillChecker: Bool = true
        
        switch(textField.tag) {
            
        case TextfieldType.Year.rawValue:
            debugPrint("year")
        case TextfieldType.Make.rawValue:
            
            if "" == self.yearTextField.text || self.yearTextField.text == "Year"{
                CommonUtils.showAlert("Error", message: "Please fill the year field")
                fillChecker = false
            }
            
        case TextfieldType.Model.rawValue:
            
            if ("" == self.yearTextField.text && "" == self.makeTextField.text) || ("Year" == self.yearTextField.text && "Make" == self.makeTextField.text) {
                CommonUtils.showAlert("Error", message: "Please fill the year and make field")
                fillChecker = false
                
            } else if "" == self.yearTextField.text  || self.yearTextField.text == "Year"{
                CommonUtils.showAlert("Error", message: "Please fill the year field")
                fillChecker = false
            } else if "" == self.makeTextField.text  || self.makeTextField.text == "Make"{
                CommonUtils.showAlert("Error", message: "Please fill the make field")
                fillChecker = false
            }
            
        case TextfieldType.EngineSize.rawValue:
            if ("" == self.yearTextField.text && "" == self.makeTextField.text && "" == self.modelTextField.text) || ("Year" == self.yearTextField.text && "Make" == self.makeTextField.text && "Model" == self.modelTextField.text) {
                CommonUtils.showAlert("Error", message: "Please fill the year make and model field")
                fillChecker = false
                
            }
            else if ("" == self.makeTextField.text && "" == self.modelTextField.text) || ("Make" == self.makeTextField.text && "Model" == self.modelTextField.text) {
                CommonUtils.showAlert("Error", message: "Please fill the make and model field")
                fillChecker = false
                
            }
            else if "" == self.makeTextField.text  || self.makeTextField.text == "Year"{
                CommonUtils.showAlert("Error", message: "Please fill the make field")
                fillChecker = false
            } else if "" == self.modelTextField.text  || self.modelTextField.text == "Make"{
                CommonUtils.showAlert("Error", message: "Please fill the model field")
                fillChecker = false
            }
        default:
            break
        }
        self.animateTextField(textField, up: true)
        return fillChecker
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch(textField.tag) {
            
        case TextfieldType.Year.rawValue:
            
            let year = self.yearTextField.text
            
            if "" != year && "Year" != year && 4 <= year?.characters.count {
                
                if 0 != makes.count {
                    self.makes.removeAll()
                }
                //Show Progress Hud
                CommonUtils.showProgress(self.view, label: "Getting Data...")
                Network.sharedInstance.getRepairMakeFromYear(self.yearTextField.text!) { (data) -> Void in
                    //Hide Progress Hud
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonUtils.hideProgress()
                    })
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.makes = data!
                        self.makes.insert("Make", atIndex: 0)
                        self.yearTextField.resignFirstResponder()
                        self.makePickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        CommonUtils.showAlert("Error", message: "Please correct searched fields")
                    }
                }
            } else {
            }
            
        case TextfieldType.Make.rawValue:
            
            let year = self.yearTextField.text
            let make = self.makeTextField.text
            
            if "" != make && "" != year && "Make" != make && "Year" != year {
                
                if 0 != models.count {
                    self.models.removeAll()
                }
                //Show Progress Hud
                CommonUtils.showProgress(self.view, label: "Getting Data...")
                Network.sharedInstance.getRepairModel(year!, make: make!, completion: { (data) -> Void in
                    //Hide Progress Hud
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonUtils.hideProgress()
                    })
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.models = data!
                        self.models.insert("Model", atIndex: 0)
                        self.makeTextField.resignFirstResponder()
                        self.modelPickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        CommonUtils.showAlert("Error", message: "Please correct searched fields")
                    }
                })
            } else {
            }
        
        case TextfieldType.Model.rawValue:
            
            let year = self.yearTextField.text
            let make = self.makeTextField.text
            let model = self.modelTextField.text
            
            if "" != make && "" != year && "Make" != make && "Year" != year && "" != model && "Model" != model{
                
                if 0 != engines.count {
                    self.engines.removeAll()
                }
                //Show Progress Hud
                CommonUtils.showProgress(self.view, label: "Getting Data...")
                Network.sharedInstance.getEngines(year!, make: make!, model: model!, completion: { (data) -> Void in
                    //Hide Progress Hud
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonUtils.hideProgress()
                    })
                    if (nil != data) {
                        print("engine", data)
                        self.engines = data!
                        self.engines.insert("Engine", atIndex: 0)
                        self.engineSizeTextField.resignFirstResponder()
                        self.enginePickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        CommonUtils.showAlert("Error", message: "Please correct searched fields")
                    }
                })
            } else {
            }
            
        default:
            break
            
        }
        self.animateTextField(textField, up: false)
    }
    
    private func shouldCleanTextFields(forTag tag: Int) {
        
        switch(tag) {
        case TextfieldType.Year.rawValue:
            self.makeTextField.text = ""
            self.modelTextField.text = ""
            self.engineSizeTextField.text = ""
            
        case TextfieldType.Make.rawValue:
            self.modelTextField.text = ""
            self.engineSizeTextField.text = ""
            
        case TextfieldType.Model.rawValue:
            self.engineSizeTextField.text = ""
            
        default:
            break
        }
    }
    func animateTextField(textField: UITextField, up: Bool){     // move view up or down if textfield is hidden by keyboard.
        let movementDistance = 80
        let movementDuration = 0.3
        
        let movement = (up ? -movementDistance : movementDistance)
        let movement_float = CGFloat(movement)
        
        let frame = textField.frame
        
        if (frame.origin.y > self.view.frame.size.height / 2){
            UIView.beginAnimations("animate", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = CGRectOffset(self.view.frame, 0, movement_float)
            UIView.commitAnimations()
        }
    }
}
