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
    case VinNumber = 1
    case Year = 2
    case Make = 3
    case Model = 4
    case EngineSize = 5
}

private enum InfoType: Int {
    case Photo = 0
    case VinNumber = 1
    case Details = 2
}

class VehicleDetailsViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var insertPhotoButton: UIButton!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var engineSizeTextField: UITextField!
    @IBOutlet weak var submitResultButton: UIButton!
    
    
    private var photo: UIImage?
    private var selectedTextfieldFrame: CGRect = CGRectZero
    private var selectedTextfieldType: TextfieldType = .None
    private var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set VC title and back button
        self.navigationItem.title = "Vehicle Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.vinNumberTextField.layer.borderWidth = 2
        self.vinNumberTextField.layer.borderColor = UIColor.whiteColor().CGColor
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.vinNumberTextField.attributedPlaceholder = NSAttributedString(string: "VIN NUMBER", attributes: attributesDictionary)
        
        self.submitResultButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        let fixedWidthBarItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedWidthBarItem.width = 10
        
        let keyboardToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .Plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardBackButton(_:))), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .Plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)]
        let yearToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .Plain, target: self, action: "didPressKeyboardBackButton:"), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .Plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(VehicleDetailsViewController.didPressHideKeyboardButton(_:)))]
        
        let textfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        textfieldToolbar.items = keyboardToolbarItems
        
        let yearTextfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        yearTextfieldToolbar.items = yearToolbarItems
        
        self.yearTextField.inputAccessoryView = yearTextfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributesDictionary)
        
        self.makeTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.makeTextField.attributedPlaceholder = NSAttributedString(string: "Make", attributes: attributesDictionary)
        
        self.modelTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.modelTextField.attributedPlaceholder = NSAttributedString(string: "Model", attributes: attributesDictionary)
        
        self.engineSizeTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.engineSizeTextField.attributedPlaceholder = NSAttributedString(string: "Engine Size", attributes: attributesDictionary)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VehicleDetailsViewController.onKeyboardFrameChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    func didPressKeyboardBackButton(sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .Make:
            self.yearTextField.becomeFirstResponder()
        case .Model:
            self.makeTextField.becomeFirstResponder()
        case .EngineSize:
            self.modelTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressKeyboardForwardButton(sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .Year:
            self.makeTextField.becomeFirstResponder()
        case .Make:
            self.modelTextField.becomeFirstResponder()
        case .Model:
            self.engineSizeTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressHideKeyboardButton(sender: UIBarButtonItem) {
        
        if .Year == self.selectedTextfieldType {
            self.yearTextField.resignFirstResponder()
        }
    }
    
    @IBAction func didPressSubmitButton(sender: UIButton) {
        
        if nil != self.photo {
            
        } else if "" != self.vinNumberTextField.text {
            
        } else {
            
            if "" == self.yearTextField.text {
                self.showNotificationAlertWithTitle("Please enter Year", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.yearTextField.becomeFirstResponder()
                })
            } else if "" == self.makeTextField.text {
                self.showNotificationAlertWithTitle("Please enter Make", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.makeTextField.becomeFirstResponder()
                })
            } else if "" == self.modelTextField.text {
                self.showNotificationAlertWithTitle("Please enter Model", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.modelTextField.becomeFirstResponder()
                })
            } else if "" == self.engineSizeTextField.text {
                self.showNotificationAlertWithTitle("Please enter Engine Size", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.engineSizeTextField.becomeFirstResponder()
                })
            } else {
                self.performSegueWithIdentifier(ShowSegue.VehicleDetails.Search.rawValue, sender: InfoType.Details.rawValue)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.ScreenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight > nonKeyboardHeight {
            
            self.table.setContentOffset(CGPointMake(0, textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight + 10), animated: true)
        }
    }
    
    private func enableDisableButtonsInTextfield(textField: UITextField) {
        
        if let toolbar = textField.inputAccessoryView as? UIToolbar, type = TextfieldType(rawValue: textField.tag) {
            
            if let backButton = toolbar.items?[1] {
                backButton.enabled = TextfieldType.Year != type
            }
            if let forwardButton = toolbar.items?[3] {
                forwardButton.enabled = TextfieldType.EngineSize != type
            }
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        self.selectedTextfieldFrame = textField.frame
        self.changeTableOffset()
        self.enableDisableButtonsInTextfield(textField)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        if segue.identifier == ShowSegue.VehicleDetails.Search.rawValue {
            
            if let senderValue = sender as? Int, goType = InfoType(rawValue: senderValue) {
                
                let controller = segue.destinationViewController as! SearchViewController
                
                switch goType {
                case .Details:
                    controller.inputCarInfo = CarInfo(year: self.yearTextField.text, make: self.makeTextField.text, model: self.modelTextField.text, engineSize: self.engineSizeTextField.text)
                default:
                    debugPrint("Unknown Type")
                }
            }
        }
    }
}
