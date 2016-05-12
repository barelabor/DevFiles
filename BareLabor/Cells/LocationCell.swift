//
//  LocationCell.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

protocol CallOrLocationButtonDelegate {
    
    func callOrLocationButtonPressed(item: NSIndexPath, sentderTag:Int)
}

class LocationCell: UITableViewCell {

    @IBOutlet weak var shopeNameLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var indexPath : NSIndexPath!
    
    var delegate: CallOrLocationButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didCallOrLocationButtonPressed (sender: UIButton!){
        self.delegate?.callOrLocationButtonPressed(self.indexPath, sentderTag: sender.tag)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
