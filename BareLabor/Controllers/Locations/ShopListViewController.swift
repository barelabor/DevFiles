//
//  ShopListViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

enum TappedButton: Int {
    case Call = 0
    case Location = 1
}

class ShopListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,  CallOrLocationButtonDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    var inputCarInfo: [String:String]?
    
    private var shopList : [[String:AnyObject]] = []

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Locations"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.table.tableFooterView = UIView(frame: CGRectZero)
        
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.showHUDAddedTo(applicationDelegate.window, animated: true)
        
        LocationManager.sharedInstance.startManagerWithCompletion({ (error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if nil != error {
                    MBProgressHUD.hideAllHUDsForView(applicationDelegate.window, animated: true)
                    self.showNotificationAlertWithTitle("Warning", message: error?.localizedDescription, cancelButtonTitle: "OK", actionHandler: nil)
                } else {
                    
                    if let location = LocationManager.sharedInstance.manager?.location {
                        Network.sharedInstance.getNearestLocationWithLocationLatitude(location.coordinate.latitude, locationLongitude: location.coordinate.longitude, completion: { (data, errorMessage) -> Void in
                            
                            MBProgressHUD.hideAllHUDsForView(applicationDelegate.window, animated: true)
                            if nil != data {
                                self.shopList = data!
                                self.table.reloadData()
                            } else {
                                self.showNotificationAlertWithTitle("Warning", message: errorMessage, cancelButtonTitle: "OK", actionHandler: nil)
                            }
                        })
                    } else {
                        MBProgressHUD.hideAllHUDsForView(applicationDelegate.window, animated: true)
                        self.showNotificationAlertWithTitle("Warning", message: "Cannot retrieve your location", cancelButtonTitle: "OK", actionHandler: nil)
                    }
                }
            })
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let dictionary = self.shopList[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        cell.shopeNameLabel.text = dictionary["f_location"] as? String
        cell.addressNameLabel.text = LocationManager.getFullAddressStringFromInfo(dictionary, addAddress: true)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView( tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if nil != self.inputCarInfo {
            let viewFrame = CGRectMake(0.0, 0.0, Constants.Size.ScreenWidth.rawValue, 110.0)
            let header = CarInfoView.init(frame: viewFrame)
            header.setYear("1918", make: "Mercedes-Bens", model: "T1000", engineSize: "8.5L Diesel")
            return header
        }
        return nil
    }
    
    func tableView( tableView: UITableView,heightForHeaderInSection section: Int) -> CGFloat{
        return (nil == self.inputCarInfo ? 0.0 : 110.0)
    }
    
    // MARK: - Delegate methods

    func callOrLocationButtonPressed(item: NSIndexPath, sentderTag: Int) {
        
        if let buttonTapped = TappedButton(rawValue: sentderTag){
            
            let dictionary = self.shopList[item.row]
            switch buttonTapped {
            case .Call:
                
                if let phone = dictionary["f_telephone"] as? String {
                    LocationManager.callToThePhone(phone);
                }
            case .Location:
                self.performSegueWithIdentifier(ShowSegue.ShopList.LocationMap.rawValue, sender:dictionary)
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == ShowSegue.ShopList.LocationMap.rawValue {
            if let info = sender as? [String:AnyObject] {
                let controller = segue.destinationViewController as! LocationMapViewController
                controller.info = info
                controller.navigationItem.title = info["name"] as? String
                
            }
        }
    }
}
