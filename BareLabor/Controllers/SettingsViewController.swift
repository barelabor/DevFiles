//
//  SettingsViewController.swift
//
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum SettingsButtonTags: Int {
    case Home = 4
    case ViewMyHistory = 0
    case PrivacyPolicy = 1
    case TermOfUse = 2
    case LoginOut = 3
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var viewMyHistory : UIButton!
    @IBOutlet weak var privacyPolicy : UIButton!
    @IBOutlet weak var termsOfUse : UIButton!
    @IBOutlet weak var loginOut : UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    var loginStatus:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBarHidden = true
        self.viewMyHistory.layer.borderColor = UIColor.whiteColor().CGColor
        self.privacyPolicy.layer.borderColor = UIColor.whiteColor().CGColor
        self.termsOfUse.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginOut.layer.borderColor = UIColor.whiteColor().CGColor
        self.homeBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.setLoginButtonText() //check on login
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    //MARK: - IBAction methods
    
    @IBAction func didSettingsButtonsPressed(sender: UIButton){
        if let item = SettingsButtonTags(rawValue: sender.tag){
            switch item {
            case .Home:
                let mainMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController!
                self.navigationController?.pushViewController(mainMenuViewController, animated: true)
                break;
            case .ViewMyHistory :
                // If not logged in display alert.
                if NSUserDefaults.standardUserDefaults().objectForKey("userID") == nil
                {
                    CommonUtils.showAlert("Sorry", message: "You have must login/register to use this feature.")
                    return
                }
                // If there's no history avaiable display alerts
                if NSUserDefaults.standardUserDefaults().objectForKey("estimateID") == nil
                {
                    CommonUtils.showAlert("Sorry", message: "No History is Available.")
                    return
                }
                
                let userID = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! String!
                let estimateIDNumber = NSUserDefaults.standardUserDefaults().objectForKey("estimateID") as! NSNumber!
                let estimateID = "\(estimateIDNumber)" as String!
                
                let dict = ["userID": userID, "estimateID": estimateID]
                CommonUtils.showProgress(self.view, label: "Loading Information...")
                WebServiceObject.postRequest(WebServiceObject.getEstimatesURL, requestDict: dict) { (data, response, error) -> Void in
                    
                    // hide progress in main queue
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        CommonUtils.hideProgress()
                    })
                    
                    // received and check data
                    
                    if response!.statusCode == 200 {
                        let item = data!["item"] as! NSDictionary
                        if let _ = item["estimateID"] {
                            
                            let highCost = item["highCost"] as! String!
                            let averageCost = item["averageCost"] as! String!
                            let lowCost = item["lowCost"] as! String!
                            
                            if highCost == "" || averageCost == "" || lowCost == "" {
                                print("failed")
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    CommonUtils.showAlert("Almost There!", message: "Your last submission was not confirmed yet. Please try again soon.")
                                })
                                return
                            }
                            ChartViewController.lowValue = lowCost
                            ChartViewController.averageValue = averageCost
                            ChartViewController.highValue = highCost
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let chartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController!
                                self.navigationController?.pushViewController(chartViewController, animated: true)
                                
                            })
                        }
                            
                        else{
                            CommonUtils.showAlert("Sorry", message: "No History is Available.")
                            return
                        }
                    } else {
                        CommonUtils.showAlert("Sorry", message: "No History is Available.")
                        return
                    }
                }
            case .PrivacyPolicy :
                self.performSegueWithIdentifier(ShowSegue.Settings.TermPrivacy.rawValue, sender: SettingsButtonTags.PrivacyPolicy.rawValue)
            case .TermOfUse :
                self.performSegueWithIdentifier(ShowSegue.Settings.TermPrivacy.rawValue, sender: SettingsButtonTags.TermOfUse.rawValue)
            case .LoginOut :
                debugPrint("LOGIN OUT")
                self.toggleLoginButton() // check on login
            }
        }
    }
    
    // Set Login Button Text
    func setLoginButtonText(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let userID = defaults.valueForKey("userID")
        if userID != nil {
            self.loginStatus = true
            self.loginOut.setTitle("LOGOUT", forState: .Normal)
        }
        else{
            self.loginStatus = false
            self.loginOut.setTitle("LOGIN", forState: .Normal)
        }
        
    }
    // MARK: - Private methods
    
    func toggleLoginButton() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if self.loginStatus {
            defaults.removeObjectForKey("userID")
            CommonUtils.showAlert("OK", message: "You have successfully logged out of BareLabor.")
            self.loginStatus = !self.loginStatus
        }
        else {
            self.loginStatus = !self.loginStatus
            if let signUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(SignUpViewController.storyboardID) as? SignUpViewController {
                self.navigationController?.pushViewController(signUpController, animated: false)
            }
        }
        
        let title = (self.loginStatus) ? "LOGOUT" : "LOGIN"
        self.loginOut.setTitle(title, forState: .Normal)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowSegue.Settings.TermPrivacy.rawValue {
            if let senderValue = sender as? Int, goType = SettingsButtonTags(rawValue: senderValue) {
                
                let controller = segue.destinationViewController as! TermPrivacyViewController
                controller.showContent = goType
                
                
            }
        }
    }
    
    
}
