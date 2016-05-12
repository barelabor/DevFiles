//
//  AppDelegate.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBar"), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//        
//        application.registerUserNotificationSettings( settings )
//        application.registerForRemoteNotifications()
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

