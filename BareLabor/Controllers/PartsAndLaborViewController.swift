//
//  PartsAndLaborViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum ParkingBrake: Int {
    case Cable = 0
    case ReleaseCable = 1
    case Shoe = 2
    case Assembly = 3
}

class PartsAndLaborViewController: BaseViewController {

    @IBOutlet weak var inputCarInfoView: CarInfoView!
    @IBOutlet weak var parkingBrakeCableButton: UIButton!
    @IBOutlet weak var parkingBrakeReleaseCableButton: UIButton!
    @IBOutlet weak var parkingBrakeShoeButton: UIButton!
    @IBOutlet weak var parkingBrakeAssemblyButton: UIButton!
    
    var inputCarInfo: CarInfo!
    var searchText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Parts & Labor"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.inputCarInfoView.setYear(self.inputCarInfo.year, make: self.inputCarInfo.make, model: self.inputCarInfo.model, engineSize: self.inputCarInfo.engineSize)
        
        self.parkingBrakeCableButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeCableButton.titleLabel?.textAlignment = .Center
        self.parkingBrakeCableButton.setTitle("Remove & Replace\nParking Brake Cable", forState: .Normal)
        
        self.parkingBrakeReleaseCableButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeReleaseCableButton.titleLabel?.textAlignment = .Center
        self.parkingBrakeReleaseCableButton.setTitle("Remove & Replace\nParking Brake Release Cable", forState: .Normal)
        
        self.parkingBrakeShoeButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeShoeButton.titleLabel?.textAlignment = .Center
        self.parkingBrakeShoeButton.setTitle("Remove & Replace\nParking Brake Shoe", forState: .Normal)
        
        self.parkingBrakeAssemblyButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeAssemblyButton.titleLabel?.textAlignment = .Center
        self.parkingBrakeAssemblyButton.setTitle("Remove & Replace\nParking Brake Assembly", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func parkingButtonPressed(sender: UIButton){
        
        if let type = ParkingBrake(rawValue: sender.tag) {
            switch type {
            case .Cable:
                self.performSegueWithIdentifier(ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .ReleaseCable:
                self.performSegueWithIdentifier(ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .Shoe:
                self.performSegueWithIdentifier(ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .Assembly:
                self.performSegueWithIdentifier(ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == ShowSegue.PartsAndLabor.Results.rawValue {
            
//            if let senderValue = sender as? Int, goType = ParkingBrake(rawValue: senderValue) {
//                
//                let controller = segue.destinationViewController as! ResultsViewController
//                
//                
//            }
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
