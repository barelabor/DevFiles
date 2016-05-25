//
//  RepairDetailsViewController.swift
//  BareLabor
//
//  Created by super-pc on 5/24/16.
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class RepairDetailsViewController: UIViewController {

    @IBOutlet weak var repairNameLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    
    var repairName = "Brake"
    var lowPrice = "$100"
    var averagePrice = "$200"
    var highPrice = "$300"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.repairNameLabel.text = self.repairName as String!
        self.lowPriceLabel.text = "$" + self.lowPrice as String!
        self.averagePriceLabel.text = "$" + self.averagePrice
        self.highPriceLabel.text = "$" + self.highPrice as String!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
}
