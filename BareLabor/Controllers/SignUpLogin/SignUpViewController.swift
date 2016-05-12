//
//  SignUpViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum TextfieldType: Int {
    case None = 0
    case Username = 1
    case Useremail = 10
    case UserFullName = 2
    case Password = 4
    case VerifyPassword = 5
}

private enum SegmentedControlIndex: Int {
    case SignUp = 0
    case Login = 1
}

class SignUpViewController: BaseViewController, UITextFieldDelegate {
	
	static let storyboardID = "SignUpViewController"
	
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
//    @IBOutlet weak var userFullNameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    
    @IBOutlet weak var topContentTraling : NSLayoutConstraint!
    
    @IBOutlet weak var userNameHeight : NSLayoutConstraint!
    @IBOutlet weak var userNameIconHeight : NSLayoutConstraint!
    @IBOutlet weak var userNameSeparatorHeight : NSLayoutConstraint!
    
//    @IBOutlet weak var userFullNameHeight : NSLayoutConstraint!
//    @IBOutlet weak var userFullNameIconHeight : NSLayoutConstraint!
//    @IBOutlet weak var userFullNameSeparatorHeight : NSLayoutConstraint!
    
    @IBOutlet weak var confirmPasswordHeight : NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordIconHeight : NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordSeparatorHeight : NSLayoutConstraint!
    
//    @IBOutlet weak var userEmailHeight : NSLayoutConstraint!
//    @IBOutlet weak var userEmailIconHeight : NSLayoutConstraint!
//    @IBOutlet weak var userEmailSeparatorHeight : NSLayoutConstraint!
    
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
    private var selectedTextfieldType: TextfieldType = .None
    
    var isSignUp: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"
        
        self.signUpLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
        let fixedWidthBarItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedWidthBarItem.width = 10
        
        let keyboardToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .Plain, target: self, action: #selector(SignUpViewController.didPressKeyboardBackButton(_:))), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .Plain, target: self, action: #selector(SignUpViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)]
        
        let textfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        textfieldToolbar.items = keyboardToolbarItems
        
        self.emailTextField.inputAccessoryView = textfieldToolbar
        self.usernameTextField.inputAccessoryView = textfieldToolbar
//        userFullNameTextField.inputAccessoryView = textfieldToolbar
//        self.emailTextField.inputAccessoryView = textfieldToolbar
        self.passwordTextField.inputAccessoryView = textfieldToolbar
        self.verifyPasswordTextField.inputAccessoryView = textfieldToolbar
        
        
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Create User Name", attributes: attributesDictionary)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
//        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
//        self.userFullNameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: attributesDictionary)
//        
//        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
//        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.verifyPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Verify Password", attributes: attributesDictionary)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.onKeyboardFrameChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlValueChnged(sender: UISegmentedControl){
        if let index = SegmentedControlIndex(rawValue: sender.selectedSegmentIndex){
            UIView.animateWithDuration(0.1 , animations: { () -> Void in
                switch index {
                case .SignUp:
                    self.emailView.hidden = false
//                    self.userFullNameHeight.constant = 30
//                    self.userFullNameIconHeight.constant = 24
//                    self.userFullNameSeparatorHeight.constant = 1
//                    self.userEmailHeight.constant = 30
//                    self.userEmailIconHeight.constant = 24
//                    self.userEmailSeparatorHeight.constant = 1
                    
                    self.confirmPasswordHeight.constant = 30
                    self.confirmPasswordIconHeight.constant = 24
                    self.confirmPasswordSeparatorHeight.constant = 1
                    
                    
                    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
                    self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Create User Name", attributes: attributesDictionary)
                    
                    self.isSignUp = true
                case .Login:
                    
//                    self.userFullNameHeight.constant = 0
//                    self.userFullNameIconHeight.constant = 0
//                    self.userFullNameSeparatorHeight.constant = 0
//                    
//                    self.userEmailHeight.constant = 0
//                    self.userEmailIconHeight.constant = 0
//                    self.userEmailSeparatorHeight.constant = 0
                    self.emailView.hidden = true
                    self.confirmPasswordHeight.constant = 0
                    self.confirmPasswordIconHeight.constant = 0
                    self.confirmPasswordSeparatorHeight.constant = 0
                    
                    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
                    self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: attributesDictionary)
                    
                    self.isSignUp = false
                }
                self.view.layoutSubviews()
                },completion: { (finished: Bool) -> Void in
                    
                    
            });
        }
    }
    
    func didPressKeyboardBackButton(sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
//        case .UserFullName:
//            self.usernameTextField.becomeFirstResponder()
        case .Username:
            self.emailTextField.becomeFirstResponder()
        case .Password:
            self.usernameTextField.becomeFirstResponder()
        case .VerifyPassword:
            self.passwordTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressKeyboardForwardButton(sender: UIBarButtonItem?) {
        
        switch self.selectedTextfieldType {
        case .Useremail:
            self.usernameTextField.becomeFirstResponder()
        case .Username:
            self.passwordTextField.becomeFirstResponder()
//        case .UserFullName:
//            self.emailTextField.becomeFirstResponder()
//        case .Email:
//            self.passwordTextField.becomeFirstResponder()
        case .Password:
            self.verifyPasswordTextField.becomeFirstResponder()
        case .VerifyPassword:
            self.verifyPasswordTextField.resignFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    @IBAction func didPressSignUpButton(sender: UIButton) {
        if (isSignUp) {
            
            let userName = self.usernameTextField.text
//            let userFullName = self.userFullNameTextField.text
//            let userEmail = self.emailTextField.text
            let userPassword = self.passwordTextField.text
            let userVerifyPassword = self.verifyPasswordTextField.text
            let userEmail = self.emailTextField.text!
            
            if("" != userName && "" != userPassword && "" != userVerifyPassword && !userEmail.isEmpty) {
                if(!CommonUtils.isValidEmail(userEmail)){
                    CommonUtils.showAlert("Error", message: "Please enter correct email address.")
                    return
                }
                if (userPassword == userVerifyPassword) {
                    activityIndicator.startAnimating()
                    var deviceToken = ""
                    if(NSUserDefaults.standardUserDefaults().valueForKey("device_token") != nil){
                        deviceToken = NSUserDefaults.standardUserDefaults().valueForKey("device_token") as! String
                    }
                    Network.sharedInstance.signUP(userName!, password: userPassword!, email: userEmail,userFullName: "", deviceToken: deviceToken) { (data) -> Void in
                        self.activityIndicator.stopAnimating()
                        print(data)
                        if (nil != data) {
                            if ("CONFLICT" != data!["status"] as! String) {
                                
                                //fill user Defaults
                                self.setUserDefaults(data!)
                                
                            } else {
                                let alert = UIAlertController(title: "Warning", message: "User with current name existed", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        } else {
                            let alert = UIAlertController(title: "Warning", message: "Connection Trouble", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Warning", message: "Passwords not equal", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "Please filled all fields", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            
            let userName = self.usernameTextField.text
            let userPassword = self.passwordTextField.text
            var deviceToken = ""
            if(NSUserDefaults.standardUserDefaults().valueForKey("device_token") != nil){
                deviceToken = NSUserDefaults.standardUserDefaults().valueForKey("device_token") as! String
            }
            
            if("" != userName && "" != userPassword ) {
				activityIndicator.startAnimating()
                Network.sharedInstance.logIn(userName!, password: userPassword!, device_token: deviceToken, completion: { (data) -> Void in
                    self.activityIndicator.stopAnimating()
					
                    if (nil != data) {
                        if ("NOT_FOUND" != data!["status"] as? String) {
                            
                            //fill user Defaults
                            self.setUserDefaults(data!)
                            
                        } else {
                            
                            let alert = UIAlertController(title: "Warning", message: "Please check your login or password", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Warning", message: "Connection Problem", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Warning", message: "Please filled all fields", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func enableDisableButtonsInTextfield(textField: UITextField) {
        
        if let toolbar = textField.inputAccessoryView as? UIToolbar, type = TextfieldType(rawValue: textField.tag) {
            
            if let backButton = toolbar.items?[1] {
                backButton.enabled = .Useremail != type
            }
            if let forwardButton = toolbar.items?[4] {
                forwardButton.enabled = .VerifyPassword != type
            }
        }
    }
    
    func setUserDefaults(data:[String:AnyObject]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(data["userID"], forKey: "userID")
        defaults.setObject(data["username"], forKey: "username")
        defaults.setObject(data["email"], forKey: "email")
        
        if let userFullName = data["userFullname"] {
            defaults.setObject(userFullName, forKey: "userFullname")
        }
        
        if let userLat = data["userLat"] {
            defaults.setObject(userLat, forKey: "userLat")
        }
        
        if let userLong = data["userLong"] {
            defaults.setObject(userLong, forKey: "userLong")
        }
        
        if let userAddress = data["userAddress"] {
            defaults.setObject(userAddress, forKey: "userAddress")
        }
        
        if let userPhone = data["userPhone"] {
            defaults.setObject(userPhone, forKey: "userPhone")
            
        }
        
        if let created = data["created"] {
            defaults.setObject(created, forKey: "created")
        }
        
        if let resetToken = data["resetToken"] {
            defaults.setObject(resetToken, forKey: "resetToken")
        }
        
        if let timeAgo = data["timeAgo"] {
            defaults.setObject(timeAgo, forKey: "timeAgo")
        }
        
        if let _ = data["userAvatar"] as? NSNull {
            
        } else {
            defaults.setObject(data["userAvatar"] , forKey: "userAvatar")
        }
        
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainMenuViewController")
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        self.enableDisableButtonsInTextfield(textField)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.didPressKeyboardForwardButton(nil)
        return true
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(sender: NSNotification) {
        
        if let userInfo = sender.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            
            
            UIView.animateWithDuration((userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double)! , animations: { () -> Void in
                if keyboardFrame.origin.y < Constants.Size.ScreenHeight.floatValue {//Keyboard Up
                    self.topContentTraling.constant = -93
                    
                } else {//Keyboard Down
                    self.topContentTraling.constant = 58
                    
                }
                self.view.layoutSubviews()
                },completion: { (finished: Bool) -> Void in
                    
                    
            });
        }
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
