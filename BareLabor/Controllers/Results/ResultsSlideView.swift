//
//  ResultsSlideView.swift
//  BareLabor
//
//  Dustin Alllen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum ResultsSlideItem: Int {
    
    case NewSearch = 0
    case Settings = 1
}

protocol ResultsSlideViewDelegate {
    
    func resultsSlideDidSelectItem(item: ResultsSlideItem)
}

class ResultsSlideView: UIView {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var settingsButton: UIButton?
    @IBOutlet weak var newSearchButton: UIButton?
    @IBOutlet weak var footerTableView: UIView!
    @IBOutlet weak var deleteButton: UIButton?
    
    var delegate: ResultsSlideViewDelegate?
    var selectedSet : Set<String> = []
    var testStrings: [String] = ["Auto Spare Part Replacing Brake Pads", "Shock Absorber for Honda", "Lower Ball Joint for Toyota", "Brake Lining (FMSI: 4720 ANC CAM)", "sdf", "asdfa", "sadfasdf"]
    
    override func awakeFromNib() {
        
        if let view = NSBundle.mainBundle().loadNibNamed("ResultsSlideView", owner: self, options: nil).first as? UIView {
            
            view.frame = self.bounds
            self.addSubview(view)
            view.backgroundColor = UIColor(red: 16/255.0, green: 56/255.0, blue: 125/255.0, alpha:0.9)
            
            self.tableView?.registerNib(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
            
            self.tableView?.tableFooterView = self.footerTableView
            
            self.settingsButton!.layer.borderColor = UIColor.whiteColor().CGColor
            self.newSearchButton!.layer.borderColor = UIColor.whiteColor().CGColor
            self.deleteButton!.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
    }
    
    //MARK: - UITableViewDataSource methods
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! SlideMenuTableViewCell
        
        cell.deselectedArrow?.hidden = false
        cell.selectedArrow?.hidden = true
        if (self.selectedSet.contains(self.testStrings[indexPath.row]) == true){
            cell.selectedArrow?.hidden = false
            cell.deselectedArrow?.hidden = true
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.title?.text = self.testStrings[indexPath.row]
        
        return cell
    }
    
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.testStrings.count;
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (self.selectedSet.contains(self.testStrings[indexPath.row]) == true){
            self.selectedSet.remove(self.testStrings[indexPath.row])
        }else{
            self.selectedSet.insert(self.testStrings[indexPath.row])
        }
        tableView.reloadData()
    }
    
    //MARK: - IBAction methods
    
    @IBAction func didSlideMenuButtonsPressed(sender: UIButton){
        if let item = ResultsSlideItem(rawValue: sender.tag){
            self.delegate?.resultsSlideDidSelectItem(item)
        }
    }
    
    @IBAction func didDeleteButtonPressed(sender: UIButton){
        var testingsSet = Set(self.testStrings)
        testingsSet.subtractInPlace(self.selectedSet)
        self.testStrings = Array(testingsSet)
        self.tableView?.reloadData()
    }
    
}

