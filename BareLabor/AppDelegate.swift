//
//  AppDelegate.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mixpanel:Mixpanel?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let hasOnBoard:Bool = NSUserDefaults.standardUserDefaults().boolForKey("hasOnBoard")
        print("sadfasdfasdfsdf", hasOnBoard)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBar"), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        if (!hasOnBoard) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasOnBorad")
            NSUserDefaults.standardUserDefaults().synchronize()
            let firstPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor1.jpeg"), buttonText: nil) { () -> Void in
            }
            
            let secondPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor2.jpeg"), buttonText: nil) { () -> Void in
            }
            
            let thirdPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor3.jpeg"), buttonText: nil) { () -> Void in
            }
            
            let forthPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor4.jpeg"), buttonText: nil) { () -> Void in
            }
            
            let fivthPage = OnboardingContentViewController(title: "Options", body: "Send us an estimate for review, look up tire costs, & more!", image: UIImage(named: "barelabor5.jpeg"), buttonText: "Get Started") { () -> Void in
                self.window?.rootViewController = navigationController
            }
            fivthPage.actionButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
            let onBoardingVC: OnboardingViewController = OnboardingViewController(backgroundImage:  UIImage(named: "barelabor1.jpeg"), contents: [firstPage, secondPage, thirdPage, forthPage, fivthPage])
            onBoardingVC.shouldFadeTransitions = true
            onBoardingVC.shouldFadeTransitions = true
            onBoardingVC.fadePageControlOnLastPage = true
            onBoardingVC.fadeSkipButtonOnLastPage = true
            
            onBoardingVC.allowSkipping = true
            onBoardingVC.skipHandler = {
                self.window?.rootViewController = navigationController
            }
            self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()

            self.window?.rootViewController = onBoardingVC
        }
        else{
            self.window?.rootViewController = navigationController
        }
        
        self.window?.makeKeyAndVisible()
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//        
//        application.registerUserNotificationSettings( settings )
//        application.registerForRemoteNotifications()
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        mixpanel = Mixpanel.sharedInstanceWithToken("66230959f4d42a8bf37b20f296ef7b3e")
        
        mixpanel!.track("App launched")
        return true
    }
    
    // MARK: - Push Notifications
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        print( deviceTokenString )
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenString, forKey: "device_token")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
		debugPrint(userInfo)
		
		if let aps = userInfo["aps"] as? [NSObject : AnyObject]
		{
			if let action = aps["action"] as? [NSObject : AnyObject],
				route = action["route"] as? String,
				request = action["request"]
				where route == "mail/thread1"
			{
				if let chartController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ChartViewController.storyboardID) as? ChartViewController, rootNavController = window?.rootViewController as? UINavigationController
				{
                    chartController.prices = [request["lowCost"] as! String, request["averageCost"] as! String, request["highCost"] as! String];
                    
                    let repairArrayString = request["repairArray"] as! String!
                    let highCostArrayString = request["highCostArray"] as! String!
                    let averageCostArrayString = request["averageCostArray"] as! String!
                    let lowCostArrayString = request["lowCostArray"] as! String!
                    
                    chartController.repairArray = repairArrayString.componentsSeparatedByString(",")
                    chartController.highCostArray = highCostArrayString.componentsSeparatedByString(",")
                    chartController.averageCostArray = averageCostArrayString.componentsSeparatedByString(",")
                    chartController.lowCostArray = lowCostArrayString.componentsSeparatedByString(",")
                    chartController.isScanEstimate = true
                    
                    if (application.applicationState == .Active)
                    {
                        let alert = UIAlertController(title: nil, message: "The pricing for your printed estimate has arrived", preferredStyle: .Alert)
                        let callActionHandler = { (action:UIAlertAction!) -> Void in
                            rootNavController.pushViewController(chartController, animated: true)
                        }
                        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler:callActionHandler))
                        rootNavController.presentViewController(alert, animated: true, completion: nil)
                    }
                    else{
                        rootNavController.pushViewController(chartController, animated: true)
                    }
				}
			} else
			{
				print("No action or no route or no request")
			}
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        mixpanel!.track("App Enter Foreground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

