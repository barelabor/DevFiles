//
//  PreviewViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var retakeButton : UIButton!
    @IBOutlet weak var plusButton : UIButton!
    
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
    var image : UIImage!
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.retakeButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.image = self.image
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prefersStatusBarHidden()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressRetakeButton(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didPressPlusButton(sender: UIButton){
        if (self.images.count != 2){
            self.images.append(self.image)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            self.plusButton.enabled = false
            self.retakeButton.enabled = false
        }
    }
    
    @IBAction func didPressDoneButton(sender: UIButton)
	{
        self.activityIndicator.startAnimating()
        dispatch_async((dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)), {
            Network.sharedInstance.submitEstimateImage(self.image) { (success) -> () in
                if success
                {
                    print("Upload success")
                } else
                {
                    print("Upload failed")
                }
            }
        })
        let alert = UIAlertController(title: "Success", message: "Your estimate has been submitted! The results will be sent to you in the next 15 minutes.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
            let mainMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController!
            self.navigationController?.pushViewController(mainMenuViewController, animated: true)
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
	
    override func prefersStatusBarHidden() -> Bool {
        return true
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
