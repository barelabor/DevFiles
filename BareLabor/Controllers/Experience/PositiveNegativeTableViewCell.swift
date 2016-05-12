//
//  PositiveNegativeTableViewCell.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class PositiveNegativeTableViewCell: UITableViewCell {

    @IBOutlet weak var customAccessoryView : UIImageView!
    @IBOutlet weak var customFilledAccessoryView : UIImageView!
    @IBOutlet weak var answerLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
