//
//  ExperienceViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum ExperienceType: Int {
    case Negative = 0
    case Positive = 1
}

class ExperienceViewController: UIViewController {
    
    @IBOutlet weak var buttonsTopOffset: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Tell Us Your Experience"
        
        if 480 == UIScreen.mainScreen().bounds.size.height {
            self.buttonsTopOffset.constant = -30
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func didPosititveNegativeButtonPressed(sender: UIButton){
        if let type = ExperienceType(rawValue: sender.tag){
            switch type {
            case .Positive:
                self.performSegueWithIdentifier(ShowSegue.Experience.PositiveNegative.rawValue, sender: ExperienceType.Positive.rawValue)
            case .Negative:
                self.performSegueWithIdentifier(ShowSegue.Experience.PositiveNegative.rawValue, sender: ExperienceType.Negative.rawValue)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowSegue.Experience.PositiveNegative.rawValue {
            if let senderValue = sender as? Int, goType = ExperienceType(rawValue: senderValue) {
                let controller = segue.destinationViewController as! PositiveNegativeViewController
                controller.experience = goType
            }
        }
    }
    

}
