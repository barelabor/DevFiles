//
//  BaseViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.onLocationDenied(_:)), name: Notifications.Location.StatusDenied.rawValue, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notifications.Location.StatusDenied.rawValue, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Notification Observer
    
    func onLocationDenied(sender: NSNotification) {
        
        let alert = UIAlertController(title: "Warning", message: "Please turn on location in the Settings", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (_) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Public Method
    
    func showNotificationAlertWithTitle(title: String?, message: String?, cancelButtonTitle: String!, actionHandler: ((Void) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: { (action) -> Void in
            if nil != actionHandler {
                actionHandler!()
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
