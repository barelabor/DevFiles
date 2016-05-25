//
//  MainMenu.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
//import Alamofire
class MainMenuViewController: BaseViewController {

    @IBOutlet weak var iHaveAnEstimateButton: UIButton!
    @IBOutlet weak var iDoNotHaveAnEstimateButton: UIButton!
    @IBOutlet weak var iNeedATireButton: UIButton!
    @IBOutlet weak var iJustNeedAShopButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var repairCalcBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // if already registered or signed hide "Register/Login" Button
        
        if NSUserDefaults.standardUserDefaults().objectForKey("userID") != nil
        {
            registerBtn.hidden = true
        }
        
        self.navigationController?.navigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.iDoNotHaveAnEstimateButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.iHaveAnEstimateButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.iNeedATireButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.iJustNeedAShopButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.viewHistoryButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.repairCalcBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerRequiredBtns(sender: UIButton) {
        if NSUserDefaults.standardUserDefaults().objectForKey("userID") == nil
        {
            CommonUtils.showAlert("Sorry", message: "You have must login/register to use this feature.")
            return
        }
    
        // if "Scan My Estimate" Button is clicked
        if sender.tag == 1111 {
            let scanViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ScanViewController") as! ScanViewController!
            self.navigationController?.pushViewController(scanViewController, animated: true)
        }
            
        // if "Need a Tire" Button is clicked
            
        else if sender.tag == 1112 {
            let needTireController = self.storyboard?.instantiateViewControllerWithIdentifier("NeedTireViewController") as! NeedTireViewController!
            self.navigationController?.pushViewController(needTireController, animated: true)
        }
            
        // If "View History" Button is tapped.
            
        else {
            
            // If there's no history avaiable display alerts
            if NSUserDefaults.standardUserDefaults().objectForKey("estimateID") == nil
            {
                CommonUtils.showAlert("Sorry", message: "No History is Available.")
                return
            }
            
            let userID = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! String!
            let estimateIDNumber = NSUserDefaults.standardUserDefaults().objectForKey("estimateID") as! NSNumber!
            let estimateID = "\(estimateIDNumber)" as String!
            
            //let dict = ["userID": userID, "estimateID": estimateID]
            CommonUtils.showProgress(self.view, label: "Loading Information...")
            
            Network.sharedInstance.getEstimates(userID, estimateID: estimateID, completion: { (data) in
                
                
                // hide progress in main queue
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    
                    CommonUtils.hideProgress()
                })
                
                // received and check data
                
                //if response!.statusCode == 200 {
                    let item = data! as NSDictionary
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
                        let repairArrayString = item["repairArray"] as! String!
                        let highCostArrayString = item["highCostArray"] as! String!
                        let averageCostArrayString = item["averageCostArray"] as! String!
                        let lowCostArrayString = item["lowCostArray"] as! String!
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let chartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController!
                            
                            chartViewController.repairArray = repairArrayString.componentsSeparatedByString(",")
                            chartViewController.highCostArray = highCostArrayString.componentsSeparatedByString(",")
                            chartViewController.averageCostArray = averageCostArrayString.componentsSeparatedByString(",")
                            chartViewController.lowCostArray = lowCostArrayString.componentsSeparatedByString(",")
                            chartViewController.isScanEstimate = true
                            self.navigationController?.pushViewController(chartViewController, animated: true)

                        })
                    }
                    
                    else{
                        CommonUtils.showAlert("Sorry", message: "No History is Available.")
                        return
                    }
//                } else {
//                    CommonUtils.showAlert("Sorry", message: "No History is Available.")
//                    return
//                }
            })

        }
    }
    
    @IBAction func registerBtnTapped(sender: UIButton) {
        
        if let signUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(SignUpViewController.storyboardID) as? SignUpViewController {
                self.navigationController?.pushViewController(signUpController, animated: false)
            }
    }
    
    @IBAction func repairCalcBtnTapped(sender: UIButton) {
        let vehicleDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("vehicleDetailsViewController") as! VehicleDetailsViewController!
        self.navigationController?.pushViewController(vehicleDetailsViewController, animated: true)
    }
    @IBAction func tutorBtnTapped(sender: UIButton) {
        let firstPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor1.jpeg"), buttonText: nil) { () -> Void in
        }
        
        let secondPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor2.jpeg"), buttonText: nil) { () -> Void in
        }
        
        let thirdPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor3.jpeg"), buttonText: nil) { () -> Void in
        }
        
        let forthPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor4.jpeg"), buttonText: nil) { () -> Void in
        }
        
        let fivthPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor5.jpeg"), buttonText: "Get Started") { () -> Void in
            self.showMainView()
        }
        fivthPage.actionButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        let onBoardingVC: OnboardingViewController = OnboardingViewController(backgroundImage:  UIImage(named: "barelabor1.jpeg"), contents: [firstPage, secondPage, thirdPage, forthPage, fivthPage])
        onBoardingVC.shouldFadeTransitions = true
        onBoardingVC.shouldFadeTransitions = true
        onBoardingVC.fadePageControlOnLastPage = true
        onBoardingVC.fadeSkipButtonOnLastPage = true
        
        onBoardingVC.allowSkipping = true
        onBoardingVC.skipHandler = {
            self.showMainView()
        }
        self.navigationController?.pushViewController(onBoardingVC, animated: true)
    }
    func showMainView() {
        
        let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController!
        self.navigationController!.pushViewController(mainViewController, animated: true)
    }
}

