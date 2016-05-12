//
//  SlideMenuTableViewCell.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class SlideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var selectedArrow: UIImageView?
    @IBOutlet weak var deselectedArrow: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
