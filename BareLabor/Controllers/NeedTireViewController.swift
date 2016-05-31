//
//  NeedTireViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Mixpanel

private enum TextfieldType: Int {
    case None = 0
    case Year = 1
    case Make = 2
    case Model = 3
    case Features = 4
    case QTY1 = 5
    case Size1 = 6
    case Size2 = 7
    case Size3 = 8
    case QTY2 = 9
}

private enum PickerType: Int {
    case YearPicker = 0
    case MakePicker = 1
    case ModelPicker = 2
    case FeaturesPicker = 3
    case QuantityPicker = 4
    case WidthPicker = 5
    case RatiosPicker = 6
    case DiametersPicker = 7
}

private enum PriceMode: Int {
    case VehiclePrice = 0
    case SizePrice = 1
    
}

class NeedTireViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var featuresTextField: UITextField!
    @IBOutlet weak var qty1TextField: UITextField!
    @IBOutlet weak var byVihecleView: UIView!
    
    @IBOutlet weak var size1TextField: UITextField!
    @IBOutlet weak var size2TextField: UITextField!
    @IBOutlet weak var size3TextField: UITextField!
    @IBOutlet weak var qty2TextField: UITextField!
    @IBOutlet weak var bySizeView: UIView!
    
    
    @IBOutlet weak var choseTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var submitButtone: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // pickers by vehicle
    private var yearPickerView: UIPickerView!
    private var makePickerView: UIPickerView!
    private var modelPickerView: UIPickerView!
    private var featuresPickerView: UIPickerView!
    private var quantityPickerView: UIPickerView!
    
    private var years: [String] = []
    private var makes: [String] = []
    private var models: [String] = []
    private var features: [String] = []
    
    // pickers by size
    private var widthPickerView: UIPickerView!
    private var ratiosPickerView: UIPickerView!
    private var diamteresPickerView: UIPickerView!
    
    private var widths: [String] = []
    private var ratios: [String] = []
    private var diameters: [String] = []
    private var quantities: [String] = []
    
    private var pickerType:PickerType = .YearPicker
    
    private var quantity: String?
    private var sizePrices: [String] = []
    private var vehiclePrices: [String] = []
    
    private var selectedTextfieldFrame: CGRect = CGRectZero
    private var selectedTextfieldType: TextfieldType = .None
    private var keyboardHeight: CGFloat = 0
    
    private var priceMode: PriceMode = .VehiclePrice {
        didSet {
            if .VehiclePrice == self.priceMode {
                self.byVihecleView.hidden = false
                self.bySizeView.hidden = true
            } else {
                self.bySizeView.hidden = false
                self.byVihecleView.hidden = true
            }
        }
    }
    private var ratingArray: NSArray = []
    private var vehicleQuantity = 1
    private var sizeQuantity = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.submitButtone.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.navigationItem.title = "Need A Tire"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // tableView
        self.table.tableFooterView = UIView(frame: CGRectZero)
        
        // setup textfields and pickers
        self.setUpTextFields()
        
        //get years
        self.years = self.getYears()
        
        //get widths
        self.widths = self.getWidths()
        
        //get ratio
        self.ratios = self.getHeights()
        
        //get diameters
        self.diameters = self.getRim()
        
        //get quantities
        self.quantities = self.getQuantity()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NeedTireViewController.onKeyboardFrameChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    func didPressHideKeyboardButton(sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .Year:
            self.yearTextField.resignFirstResponder()
        case .QTY1:
            self.qty1TextField.resignFirstResponder()
        case .Size1:
            self.size1TextField.resignFirstResponder()
        case .Size2:
            self.size2TextField.resignFirstResponder()
        case .Size3:
            self.size3TextField.resignFirstResponder()
        case .QTY2:
            self.qty2TextField.resignFirstResponder()
        default:
            debugPrint("Unsupported Type")
        }
    }
    
    @IBAction func didPressSubmitButton(sender: UIButton) {
        
        let mixpanel = Mixpanel.sharedInstance()
        
        
        self.sizePrices = []
        self.vehiclePrices = []
        
        let year = self.yearTextField.text
        let make = self.makeTextField.text
        let model = self.modelTextField.text
        var feature = self.featuresTextField.text
        let quantityVehicle = self.qty1TextField.text
        
        let width = self.size1TextField.text
        let ratio = self.size2TextField.text
        let diameter = self.size3TextField.text
        let sizeQuantity = self.qty2TextField.text
        ratingArray = []
        switch(self.priceMode) {
            
        case .VehiclePrice:
            
            mixpanel.track("Vehicle Submit clicked")
            
            if ("" != year && "" != make && "" != model && "" != quantityVehicle && "Year" != year && "Make" != make && "Model" != model) {
                CommonUtils.showProgress(self.view, label: "Reading data...")
                if (feature == "Features") {
                    feature = ""
                }
                Network.sharedInstance.getPriceByVehicle(year!, make: make!, model: model!, feature: feature!, completion: { (data, ratingArray) -> Void in
                    self.submitButtone.enabled = true;
                    dispatch_async(dispatch_get_main_queue(), {
                      CommonUtils.hideProgress()
                    })
                    if (nil != data) {                        
                        for price in data! {
                            let newPrice = Int(Double(price)! * Double(quantityVehicle!)!)
                            self.vehiclePrices.append(String(newPrice))
                        }
                        self.ratingArray = ratingArray
                        self.vehicleQuantity = Int(quantityVehicle!)!
                        self.performSegueWithIdentifier(ShowSegue.NeedTire.Chart.rawValue, sender: self)
                        
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
                self.showAlertWithMessage("Please fill searched fields")
            }
            break;
            
        case .SizePrice:
            
            mixpanel.track("Size Submit clicked")
            
            if ("" != width && "" != ratio && "" != diameter && "" != sizeQuantity) {
                CommonUtils.showProgress(self.view, label: "Reading data...")
                Network.sharedInstance.getPriceBySize(width!, ratio: ratio!, diameter: diameter!, completion: { (data, ratingArray) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonUtils.hideProgress()
                    })
                    self.submitButtone.enabled = true;
                    if (nil != data) {
                        for price in data! {
                            let newPrice = Double(price)! * Double(sizeQuantity!)!
                            self.sizePrices.append(String(newPrice))
                        }
                        self.ratingArray = ratingArray
                        self.sizeQuantity = Int(sizeQuantity!)!
                        self.performSegueWithIdentifier(ShowSegue.NeedTire.Chart.rawValue, sender: self)
                        
                    } else {
                        self.showAlertWithMessage("There's no data for searched fields in database. Please correct searched fields.")
                    }
                })
            } else {
                self.showAlertWithMessage("Please fill searched fields")
            }
            break;
        }
    }
    
    @IBAction func didPressSaveMyCarButton(sender: UIButton) {
        self.performSegueWithIdentifier(ShowSegue.NeedTire.SignUp.rawValue, sender: nil)
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
    
    func didPressFeaturesPickerViewDone(sender: UIBarButtonItem) {
        self.featuresTextField.resignFirstResponder()
    }
    
    func didPressQuantity1PickerViewDone(sender: UIBarButtonItem) {
        self.qty1TextField.resignFirstResponder()
    }
    
    func didPressQuantity2PickerViewDone(sender: UIBarButtonItem) {
        self.qty2TextField.resignFirstResponder()
    }
    
    @IBAction func segmentDidChange(sender: AnyObject) {
        switch(sender.selectedSegmentIndex) {
        case PriceMode.VehiclePrice.rawValue:
            self.priceMode = .VehiclePrice
        case PriceMode.SizePrice.rawValue:
            self.priceMode = .SizePrice
        default:
            break
        }
    }
    
    // MARK: - Private Method
    
    private func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.ScreenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight > nonKeyboardHeight {
            
            self.table.setContentOffset(CGPointMake(0, textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight + 10), animated: true)
        }
    }
    
    private func setUpTextFields() {
        
        // keyBoard
        let textfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        textfieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressHideKeyboardButton(_:)))]
        
        // year textField
        
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributesDictionary)
        self.yearPickerView = UIPickerView()
        self.yearPickerView.showsSelectionIndicator = true
        self.yearPickerView.delegate = self
        self.yearPickerView.dataSource = self
        self.yearPickerView.tag = PickerType.YearPicker.rawValue
        self.yearTextField.inputView = self.yearPickerView
        
        let yearTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        yearTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressYearTextFieldDone(_:)))]
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
        makeTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressMakePickerViewDone(_:)))]
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
        modelTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressModelPickerViewDone(_:)))]
        self.modelTextField.inputAccessoryView = modelTextFieldToolbar
        
        // featuresTextField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.featuresTextField.attributedPlaceholder = NSAttributedString(string: "Features", attributes: attributesDictionary)
        self.featuresPickerView = UIPickerView()
        self.featuresPickerView.showsSelectionIndicator = true
        self.featuresPickerView.delegate = self
        self.featuresPickerView.dataSource = self
        self.featuresPickerView.tag = PickerType.FeaturesPicker.rawValue
        self.featuresTextField.inputView = self.featuresPickerView
        
        let featuresTextFieldToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        featuresTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressFeaturesPickerViewDone(_:)))]
        self.featuresTextField.inputAccessoryView = featuresTextFieldToolbar
        
        // quantity TextFields
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.quantityPickerView = UIPickerView()
        self.quantityPickerView.showsSelectionIndicator = true
        self.quantityPickerView.delegate = self
        self.quantityPickerView.dataSource = self
        self.quantityPickerView.tag = PickerType.QuantityPicker.rawValue
        self.qty1TextField.inputView = self.quantityPickerView
        self.qty2TextField.inputView = self.quantityPickerView
        
        let quantity1Toolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        quantity1Toolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressQuantity1PickerViewDone(_:)))]
        self.qty1TextField.inputAccessoryView = quantity1Toolbar
        
        let quantity2Toolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        quantity1Toolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(NeedTireViewController.didPressQuantity2PickerViewDone(_:)))]
        self.qty2TextField.inputAccessoryView = quantity2Toolbar
        
        // width textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        self.size1TextField.attributedPlaceholder = NSAttributedString(string: "Tire Width", attributes: attributesDictionary)
        
        self.widthPickerView = UIPickerView()
        self.widthPickerView.showsSelectionIndicator = true
        self.widthPickerView.delegate = self
        self.widthPickerView.dataSource = self
        self.widthPickerView.tag = PickerType.WidthPicker.rawValue
        self.size1TextField.inputView = self.widthPickerView
        
        // ratio textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        self.size2TextField.attributedPlaceholder = NSAttributedString(string: "Aspect Ratio", attributes: attributesDictionary)
        
        self.ratiosPickerView = UIPickerView()
        self.ratiosPickerView.showsSelectionIndicator = true
        self.ratiosPickerView.delegate = self
        self.ratiosPickerView.dataSource = self
        self.ratiosPickerView.tag = PickerType.RatiosPicker.rawValue
        self.size2TextField.inputView = self.ratiosPickerView
        
        // diameter textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        self.size3TextField.attributedPlaceholder = NSAttributedString(string: "Rim Diameter", attributes: attributesDictionary)
        
        self.diamteresPickerView = UIPickerView()
        self.diamteresPickerView.showsSelectionIndicator = true
        self.diamteresPickerView.delegate = self
        self.diamteresPickerView.dataSource = self
        self.diamteresPickerView.tag = PickerType.DiametersPicker.rawValue
        self.size3TextField.inputView = self.diamteresPickerView
        
        
        self.qty1TextField.inputAccessoryView = textfieldToolbar
        self.size1TextField.inputAccessoryView = textfieldToolbar
        self.size2TextField.inputAccessoryView = textfieldToolbar
        self.size3TextField.inputAccessoryView = textfieldToolbar
        self.qty2TextField.inputAccessoryView = textfieldToolbar
        
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
                    self.showAlertWithMessage("Please correct searched fields")
                }
            }
        }
        
        return years
    }
    
    private func getWidths() -> [String] {
        
        var widths = [String]()
        
        var counter = 10
        
        for var i = 105; i <= 395; i = i + counter {
            
            if 355 == i {
                counter = 20
            }
            
            widths.append(String(i))
        }
        
        for var i = 24; i <= 42; i += 1 {
            widths.append(String(i) + "X")
        }
        
        widths.append(String(7))
        widths.append(String(7.5))
        widths.append(String(8))
        widths.append(String(8.75))
        widths.append(String(9.5))
        
        self.size1TextField.text = widths[0] // set default width
        return widths
    }
    
    private func getHeights() -> [String] {
        var heights = [String]()
        
        let counter = 5
        
        for var i = 20; i <= 95; i = i + counter {
            heights.append(String(i))
        }
        
        let doubleCounter = 0.5
        
        for var i = 7.5; i <= 18.5; i = i + doubleCounter {
            heights.append(String(i))
        }
        heights.append("0")
        
        self.size2TextField.text = heights[0] // set default ratio
        
        return heights
    }
    
    private func getRim() -> [String] {
        var rims = [String]()
        
        var counter = 2
        
        for var i = 10; i <= 16; i = i + counter {
            
            rims.append(String(i))
            if 12 == i {
                counter = 1
            }
            
        }
        
        for var i = 16.5; i  <= 20; i = i + 0.5 {
            rims.append(String(i))
        }
        
        counter = 1
        
        for var i = 21; i <= 30; i = i + counter {
            
            rims.append(String(i))
            if 26 == i {
                counter = 2
            }
        }
        
        rims.sortInPlace(<)
        
        self.size3TextField.text = rims[0] // set default diameter
        
        return rims
    }
    
    private func getQuantity() -> [String] {
        var quantities = [String]()
        
        for var i = 1; i <= 12; i += 1 {
            quantities.append(String(i))
        }
        
        // set defaults quantities
        self.qty1TextField.text = quantities[0]
        self.qty2TextField.text = quantities[0]
        
        return quantities
    }
    
    private func showAlertWithMessage(message: String) {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (alertController) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        defer {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    private func shouldCleanTextFields(forTag tag: Int) {
        
        switch(tag) {
        case TextfieldType.Year.rawValue:
            self.makeTextField.text = ""
            self.modelTextField.text = ""
            self.featuresTextField.text = ""
            
        case TextfieldType.Make.rawValue:
            self.modelTextField.text = ""
            self.featuresTextField.text = ""
            
        case TextfieldType.Model.rawValue:
            self.featuresTextField.text = ""
            
        default:
            break
        }
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
        case PickerType.FeaturesPicker.rawValue:
            returnValue = self.features.count
        case PickerType.QuantityPicker.rawValue:
            returnValue = self.quantities.count
        case PickerType.WidthPicker.rawValue:
            returnValue = self.widths.count
        case PickerType.RatiosPicker.rawValue:
            returnValue = self.ratios.count
        case PickerType.DiametersPicker.rawValue:
            returnValue = self.diameters.count
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
            
        case PickerType.FeaturesPicker.rawValue:
            if 0 != self.features.count {
                returnValue = self.features[row]
            }
        case PickerType.QuantityPicker.rawValue:
            returnValue = self.quantities[row]
        case PickerType.WidthPicker.rawValue:
            returnValue = self.widths[row]
        case PickerType.RatiosPicker.rawValue:
            returnValue = self.ratios[row]
        case PickerType.DiametersPicker.rawValue:
            returnValue = self.diameters[row]
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
            
        case PickerType.FeaturesPicker.rawValue:
            
            if 0 != self.features.count {
                self.featuresTextField.text = self.features[row]
            }
            
        case PickerType.QuantityPicker.rawValue:
            
            if .QTY1 == self.selectedTextfieldType {
                self.qty1TextField.text = self.quantities[row]
            } else {
                self.qty2TextField.text = self.quantities[row]
            }
            
        case PickerType.WidthPicker.rawValue:
            self.size1TextField.text = self.widths[row]
        case PickerType.RatiosPicker.rawValue:
            self.size2TextField.text = self.ratios[row]
        case PickerType.DiametersPicker.rawValue:
            self.size3TextField.text = self.diameters[row]
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
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            }
            
        case TextfieldType.Model.rawValue:
            
            if ("" == self.yearTextField.text && "" == self.makeTextField.text) || ("Year" == self.yearTextField.text && "Make" == self.makeTextField.text) {
                self.showAlertWithMessage("Please fill the year and make fields")
                fillChecker = false
                
            } else if "" == self.yearTextField.text  || self.yearTextField.text == "Year"{
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            } else if "" == self.makeTextField.text  || self.makeTextField.text == "Make"{
                self.showAlertWithMessage("Please fill the make field")
                fillChecker = false
            }
            
        case TextfieldType.Features.rawValue:
            
            if ("" == self.yearTextField.text && "" == self.makeTextField.text && "" == self.modelTextField.text) || ("Year" == self.yearTextField.text && "Make" == self.makeTextField.text && "Model" == self.modelTextField.text){
                self.showAlertWithMessage("Please fill the and year, make and model fields")
                fillChecker = false
                
            } else if "" == self.yearTextField.text || self.yearTextField.text == "Year"{
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            } else if "" == self.makeTextField.text || self.makeTextField.text == "Make"{
                self.showAlertWithMessage("Please fill the make field")
                fillChecker = false
            } else if "" == self.modelTextField.text || self.modelTextField.text == "Model"{
                self.showAlertWithMessage("Please fill the model field")
                fillChecker = false
            }
            
        case TextfieldType.QTY1.rawValue:
            break
        case TextfieldType.Size1.rawValue:
            break
        case TextfieldType.Size2.rawValue:
            break
        case TextfieldType.Size3.rawValue:
            break
        case TextfieldType.QTY2.rawValue:
            break
        default:
            break
        }
        
        // keyboard
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        
        var frame = textField.frame
        
        if .Year == self.selectedTextfieldType || .Make == self.selectedTextfieldType || .Model == self.selectedTextfieldType || .Features == self.selectedTextfieldType || .QTY1 == self.selectedTextfieldType{
            frame.origin.y += (self.byVihecleView.frame.origin.y + (.QTY1 != self.selectedTextfieldType ? self.qty1TextField.frame.size.height : 0) + (.Features != self.selectedTextfieldType ? self.featuresTextField.frame.size.height : 0))
        }
        
        if .Size1 == self.selectedTextfieldType || .Size2 == self.selectedTextfieldType || .Size3 == self.selectedTextfieldType || .QTY2 == self.selectedTextfieldType{
            frame.origin.y += (self.bySizeView.frame.origin.y + (.QTY2 != self.selectedTextfieldType ? self.qty2TextField.frame.size.height : 0))
        }
        
        self.selectedTextfieldFrame = frame
        self.changeTableOffset()
        
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
            Network.sharedInstance.getMakeFromYear(self.yearTextField.text!) { (data) -> Void in
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
                        self.showAlertWithMessage("Please correct searched fields")
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
                Network.sharedInstance.getModel(year!, make: make!, completion: { (data) -> Void in
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
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
            }
            
        case TextfieldType.Model.rawValue:
            
            self.modelTextField.userInteractionEnabled = true
            
            let year = self.yearTextField.text
            let make = self.makeTextField.text
            let model = self.modelTextField.text
            
            if "" != year && "" != make && "" != model && "Year" != year && "Make" != make && "Model" != model{
                
                if 0 != features.count {
                    self.features.removeAll()
                }
                //Show Progress Hud
                CommonUtils.showProgress(self.view, label: "Getting Data...")
                Network.sharedInstance.getFeatures(year!, make: make!, model: model!, completion: { (data) -> Void in
                    //Hide Progress Hud
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonUtils.hideProgress()
                    })
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.features = data!
                        self.features.insert("Features", atIndex: 0)
                        self.modelTextField.resignFirstResponder()
                        self.featuresPickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
            }
            
        default:
            break
            
        }
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(sender: NSNotification) {
        
        if let userInfo = sender.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if keyboardFrame.origin.y < Constants.Size.ScreenHeight.floatValue {//Keyboard Up
                
                self.table.scrollEnabled = false
                self.keyboardHeight = keyboardFrame.size.height
                self.changeTableOffset()
            } else {//Keyboard Down
                
                self.table.scrollEnabled = true
                self.keyboardHeight = 0
                self.selectedTextfieldFrame = CGRectZero
                self.selectedTextfieldType = .None
                self.table.setContentOffset(CGPointMake(0, -64), animated: true)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowSegue.NeedTire.Chart.rawValue {
            
            if let controller = segue.destinationViewController as? ChartViewController {
                debugPrint("show chart controller")
                
                switch(self.priceMode) {
                case .VehiclePrice:
                    controller.prices = self.vehiclePrices
                    controller.quantity = self.vehicleQuantity
                    controller.ratingArray = self.ratingArray
                    break
                case .SizePrice:
                    controller.prices = self.sizePrices
                    controller.quantity = self.sizeQuantity
                    controller.ratingArray = self.ratingArray
                    break
                }
            }
        }
    }
}
