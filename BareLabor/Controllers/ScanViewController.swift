//
//  ScanViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ScanViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topBarView: UIView?
    @IBOutlet weak var takePictureButton: UIButton?
    var activityIndicatorView: UIActivityIndicatorView?
    
    var imagePicker : UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title viewController title
        self.navigationItem.title = "Scan"
        // Hide statusBar
        self.prefersStatusBarHidden()
        // Get view for custom camera controls from xib and add this view on imagePicker
        if let view = NSBundle.mainBundle().loadNibNamed("ImagePickerControlsView", owner: self, options: nil).first as? UIView {
            view.frame = UIScreen.mainScreen().bounds
            
            // Check avalible source type
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                self.takePictureButton?.enabled = true
                // Set topBar on cameraView
                self.topBarView?.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha:0.5)
                self.topBarView?.hidden = false
                // Set imagePickerController for showing camera
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imagePicker.showsCameraControls = false
                self.imagePicker.allowsEditing = false
                self.imagePicker.delegate = self
                self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Auto
                // Make transform for displying camera on whole screen
                let transform = CGAffineTransformMakeTranslation(0.0, 71.0);
                self.imagePicker.cameraViewTransform = transform;
                let scale = CGAffineTransformScale(transform, 1.333333, 1.333333);
                self.imagePicker.cameraViewTransform = scale;
                // Add image picker on controller
                self.imagePicker.view.addSubview(view)
                self.view.addSubview(self.imagePicker.view)
            }else{
                self.view.addSubview(view)
                self.topBarView?.hidden = true
                self.takePictureButton?.enabled = false
            }
        } 
    }
    /**
     Hide status bar
     */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction methods
    /**
    Change camra source, front or rear
     */
    @IBAction func flipButtonPressed(sender: UIButton){
        UIView.transitionWithView(self.imagePicker.view, duration: 1.0, options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.TransitionFlipFromLeft], animations: { () -> Void in
            if self.imagePicker.cameraDevice == UIImagePickerControllerCameraDevice.Rear  {
                self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front;
            } else {
                self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Rear;
            }
            
            }, completion: nil)
    }
    /**
     Close cameraCotroller
     */
    @IBAction func closeButton(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    /**
     Take photo
     */
    @IBAction func makePhoto(sender: UIButton){
        self.imagePicker.takePicture()
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        self.activityIndicatorView?.frame = self.takePictureButton!.bounds
        self.takePictureButton?.addSubview(self.activityIndicatorView!)
        self.activityIndicatorView?.startAnimating()
    }
    /**
     Show library
     */
    @IBAction func libraryPressed(sender: UIButton){
        let libraryPickerController = UIImagePickerController()
        libraryPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.navigationController?.presentViewController(libraryPickerController, animated: true, completion: nil)
        libraryPickerController.delegate = self
        
        
    }
    
    // MARK: - UIImagePickerControolerDelegate methods
    func imagePickerController( picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
            self.activityIndicatorView?.stopAnimating()
        }
        
        if let originImage = info["UIImagePickerControllerOriginalImage"]{
            self.performSegueWithIdentifier(ShowSegue.Camera.Preview.rawValue, sender: originImage)
        }
        
        
    }
    
    func imagePickerControllerDidCancel( picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    /**
    In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowSegue.Camera.Preview.rawValue {
            if let senderValue = sender as? UIImage {
                let controller = segue.destinationViewController as! PreviewViewController
                controller.image = senderValue
                
                
            }
        }
    }
    

}
