//
//  ChartViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Foundation

enum ToggleButtons: Int {
    
    case Master = 0
    case Advanced = 1
    case Intermediate = 2
    case Begginer = 3
}

class ChartViewController: UIViewController {
    
    static let storyboardID = "ChartViewController"
    
    @IBOutlet weak var chartView: ChartView!
    //@IBOutlet weak var masterButton : UIButton!
    //@IBOutlet weak var advancedButton : UIButton!
    //@IBOutlet weak var intermediateButton : UIButton!
    //@IBOutlet weak var begginerButton : UIButton!
    @IBOutlet weak var editButton : UIButton!
    //@IBOutlet weak var saveMyCarButton : UIButton!
    //@IBOutlet weak var notMyCarButton : UIButton!
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var avarageLabel: UILabel!
    @IBOutlet weak var AvaragePriceLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var guideLowValueLabel: UIButton!
    @IBOutlet weak var guideHighValueLabel: UIButton!
    var pricesForHistoryBtn: [String] = []
    var prices: [String] = []
    var ratingArray: NSArray = []
    var quantity = 1
    var transparencyButton = UIButton()
    var isScanEstimate:Bool = false
    // Set default value for low, average, high to display default values if nothing receives.
    static var lowValue = "50"
    static var averageValue = "200"
    static var highValue = "400"
    
    var repairArray: [String] = []
    var highCostArray: [String] = []
    var averageCostArray: [String] = []
    var lowCostArray: [String] = []
    var repairString:String = ""
    var repairArrayCount = 0
    
    var colorArr: [UIColor] = []
    var alert = SCLAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "What’s the Price?"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Set guide View
        
        self.guideView.layer.borderColor = UIColor.whiteColor().CGColor
        self.guideView.layer.borderWidth = 1
        self.guideView.layer.cornerRadius = 6
        
        self.editButton.layer.borderColor = UIColor.whiteColor().CGColor
        //self.notMyCarButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        // If Pushed from NeedTireViewController
        if (self.prices.count != 0) {
            self.sortPrices(self.prices)
        }
            // If Pushed from View History Button.
        else{
            self.lowPriceLabel.text =  "$"+ChartViewController.lowValue
            self.highPriceLabel.text = "$"+ChartViewController.highValue
            self.AvaragePriceLabel.text = "$"+ChartViewController.averageValue
        }
        
        if (self.isScanEstimate){
            self.colorArr=[UIColor.redColor(), UIColor.greenColor(), UIColor.whiteColor(), UIColor.blackColor(), UIColor.grayColor(), UIColor.brownColor(), UIColor.darkGrayColor(), UIColor.whiteColor(), UIColor.greenColor(), UIColor.blackColor()]
            repairArrayCount = 0
            print(self.repairArray.count)
            for x in 0 ..< self.repairArray.count{
                repairString = self.repairArray[x] as String!
                if (!repairString.isEmpty){
                    repairArrayCount = repairArrayCount + 1
                    
                }
                
            }
            
            // Set Guide Text
            let firstRepairString = self.repairArray[0].componentsSeparatedByString(" ")[0]
            self.guideLowValueLabel.setTitle(firstRepairString, forState: UIControlState.Normal)
            self.guideLowValueLabel.backgroundColor = colorArr[0]
            
            let lastRepairString = self.repairArray[repairArrayCount-1].componentsSeparatedByString(" ")[0]
            self.guideHighValueLabel.setTitle(lastRepairString, forState: UIControlState.Normal)
            self.guideHighValueLabel.backgroundColor = colorArr[repairArrayCount-1]
            if colorArr[repairArrayCount-1] == UIColor.whiteColor() {
                self.guideHighValueLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        repairArray.removeAll()
        highCostArray.removeAll()
        averageCostArray.removeAll()
        lowCostArray.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ratingArrayCount = self.ratingArray.count
        let chartViewHeight = self.chartView.frame.size.height
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        var i = 0
        if (ratingArrayCount != 0) {
            let firstSize = 100
            let heightAry : NSMutableArray=[]
            let perWidth = screenWidth/CGFloat(ratingArrayCount+1)
            for i in 0 ..< ratingArrayCount {
                heightAry.addObject(firstSize + (i * 10))
            }
            for _ in ratingArray {
                let button   = UIButton(type: UIButtonType.System) as UIButton
                button.frame = CGRectMake(perWidth*CGFloat(i+1), chartViewHeight - CGFloat(heightAry[i] as! NSNumber), 15, CGFloat(heightAry[i] as! NSNumber))
                
                // If first bar, then background color is white.
                if i == 0{
                    button.backgroundColor = UIColor.whiteColor()
                }
                    
                // If last bar, then background color will be black.
                else if i == ratingArrayCount-1{
                    button.backgroundColor = UIColor.blackColor()
                }
                
                // Other's will be gray.
                else{
                    button.backgroundColor = UIColor.grayColor()
                }
                button.addTarget(self, action: #selector(ChartViewController.barBtnsTapped(_:)), forControlEvents: .TouchUpInside)
                button.tag = i
                i = i + 1
                self.chartView.addSubview(button)
            }
        }
        if (self.isScanEstimate){

            
            let firstSize = 100
            let heightAry : NSMutableArray=[]
            let perWidth = screenWidth/CGFloat(repairArrayCount+1)
            for i in 0 ..< repairArrayCount {
                heightAry.addObject(firstSize + (i * 10))
            }
            for x in 0 ..< repairArrayCount {
                
                let button   = UIButton(type: UIButtonType.System) as UIButton
                button.frame = CGRectMake(perWidth*CGFloat(x+1), chartViewHeight - CGFloat(heightAry[x] as! NSNumber), 15, CGFloat(heightAry[x] as! NSNumber))
                
                button.backgroundColor = colorArr[x]
                button.addTarget(self, action: #selector(ChartViewController.barScanBtnsTapped(_:)), forControlEvents: .TouchUpInside)
                button.tag = x
                self.chartView.addSubview(button)
            }
            self.isScanEstimate = false
        }
    }
    
    func barScanBtnsTapped(sender: UIButton){
        let index = sender.tag
        let repairString = self.repairArray[index]
        let highCostString = self.highCostArray[index]
        let averageCostString = self.averageCostArray[index]
        let lowCostString = self.lowCostArray[index]
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,220,140))
        
        let repairLabel = UILabel(frame: CGRectMake(10, 10, 80, 30))
        repairLabel.textAlignment = NSTextAlignment.Left
        repairLabel.font = UIFont(name: (repairLabel.font?.fontName)!, size: 14)
        repairLabel.text = "Repair"
        subview.addSubview(repairLabel)
        
        let repairValueLabel = UILabel(frame: CGRectMake(90, 10, 120, 30))
        repairValueLabel.textAlignment = NSTextAlignment.Right
        repairValueLabel.textColor = UIColor.blackColor()
        repairValueLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        repairValueLabel.numberOfLines = 100
        repairValueLabel.text = repairString
        repairValueLabel.font = UIFont(name: (repairValueLabel.font?.fontName)!, size: 12)
        subview.addSubview(repairValueLabel)
        
        let highCostLabel = UILabel(frame: CGRectMake(10, 40, 80, 30))
        highCostLabel.textAlignment = NSTextAlignment.Left
        highCostLabel.textColor = UIColor.blackColor()
        highCostLabel.font = UIFont(name: (highCostLabel.font?.fontName)!, size: 14)
        highCostLabel.text = "High Cost"
        subview.addSubview(highCostLabel)
        
        let highCostValueLabel = UILabel(frame: CGRectMake(90, 40, 120, 30))
        highCostValueLabel.textAlignment = NSTextAlignment.Right
        highCostValueLabel.textColor = UIColor.blackColor()
        highCostValueLabel.font = UIFont(name: (highCostValueLabel.font?.fontName)!, size: 14)
        highCostValueLabel.text = "$\(highCostString)"
        subview.addSubview(highCostValueLabel)
        
        let averageCostLabel = UILabel(frame: CGRectMake(10, 70, 120, 30))
        averageCostLabel.textAlignment = NSTextAlignment.Left
        averageCostLabel.textColor = UIColor.blackColor()
        averageCostLabel.font = UIFont(name: (averageCostLabel.font?.fontName)!, size: 14)
        averageCostLabel.text = "Average Cost"
        subview.addSubview(averageCostLabel)
        
        let averageCostValueLabel = UILabel(frame: CGRectMake(90, 70, 120, 30))
        averageCostValueLabel.textAlignment = NSTextAlignment.Right
        averageCostValueLabel.textColor = UIColor.blackColor()
        averageCostValueLabel.font = UIFont(name: (averageCostValueLabel.font?.fontName)!, size: 14)
        averageCostValueLabel.text = "$\(averageCostString)"
        subview.addSubview(averageCostValueLabel)
        
        let lowCostLabel = UILabel(frame: CGRectMake(10, 100, 80, 30))
        lowCostLabel.textAlignment = NSTextAlignment.Left
        lowCostLabel.textColor = UIColor.blackColor()
        lowCostLabel.font = UIFont(name: (lowCostLabel.font?.fontName)!, size: 14)
        lowCostLabel.text = "Low Cost"
        subview.addSubview(lowCostLabel)
        
        let lowCostValueLabel = UILabel(frame: CGRectMake(90, 100, 120, 30))
        lowCostValueLabel.textAlignment = NSTextAlignment.Right
        lowCostValueLabel.textColor = UIColor.blackColor()
        lowCostValueLabel.font = UIFont(name: (lowCostValueLabel.font?.fontName)!, size: 14)
        lowCostValueLabel.text = "$\(lowCostString)"
        subview.addSubview(lowCostValueLabel)
        
        alert.addButton("Shop Around", action: {
            let actionSheetController = UIAlertController(title: "Select Option", message: "Where would you like to shop at?", preferredStyle: .ActionSheet)
            
            let firestoneAction = UIAlertAction(title: "Firestone", style: .Default, handler: { action -> Void in
                if let tirerackUrl = NSURL(string: "http://www.dpbolvw.net/click-8048474-11275445-1408120810000"){
                    if (UIApplication.sharedApplication().openURL(tirerackUrl)){
                        print("successfully opened")
                    }
                }
                else{
                    print("invalid url")
                }
            })
            actionSheetController.addAction(firestoneAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            })
            actionSheetController.addAction(cancelAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        })
        alert.customSubview = subview
        alert.showInfo("Repair Information", subTitle: "", closeButtonTitle: "Close")
    }
    func barBtnsTapped(sender: UIButton){
        let index = sender.tag
        let rating = self.ratingArray[index]
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,220,200))
        
        let nameLabel = UILabel(frame: CGRectMake(10, 10, 80, 50))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name: (nameLabel.font?.fontName)!, size: 12)
        nameLabel.text = "Tire Name"
        subview.addSubview(nameLabel)
        
        let nameValueLabel = UILabel(frame: CGRectMake(90, 10, 120, 50))
        nameValueLabel.textAlignment = NSTextAlignment.Right
        nameValueLabel.textColor = UIColor.blackColor()
        nameValueLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        nameValueLabel.numberOfLines = 100
        nameValueLabel.text = rating["t_name"] as! String!
        nameValueLabel.font = UIFont(name: (nameValueLabel.font?.fontName)!, size: 12)
        subview.addSubview(nameValueLabel)
        
        let priceLabel = UILabel(frame: CGRectMake(10, 60, 100, 30))
        priceLabel.textAlignment = NSTextAlignment.Left
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.font = UIFont(name: (priceLabel.font?.fontName)!, size: 12)
        priceLabel.text = "Tire Price"
        subview.addSubview(priceLabel)
        
        let priceValueLabel = UILabel(frame: CGRectMake(110, 60, 100, 30))
        priceValueLabel.textAlignment = NSTextAlignment.Right
        priceValueLabel.textColor = UIColor.blackColor()
        let t_price = rating["t_price"] as! NSString!
        let quantityPrice = CGFloat(t_price.doubleValue) * CGFloat(self.quantity)
        priceValueLabel.font = UIFont(name: (priceValueLabel.font?.fontName)!, size: 12)
        priceValueLabel.text = "$\(quantityPrice)"
        subview.addSubview(priceValueLabel)
        
        let mileageLabel = UILabel(frame: CGRectMake(10, 90, 100, 30))
        mileageLabel.textAlignment = NSTextAlignment.Left
        mileageLabel.textColor = UIColor.blackColor()
        mileageLabel.font = UIFont(name: (mileageLabel.font?.fontName)!, size: 12)
        mileageLabel.text = "Tire Mileage"
        subview.addSubview(mileageLabel)
        
        let mileageValueLabel = UILabel(frame: CGRectMake(110, 90, 100, 30))
        mileageValueLabel.textAlignment = NSTextAlignment.Right
        mileageValueLabel.textColor = UIColor.blackColor()
        mileageValueLabel.font = UIFont(name: (mileageValueLabel.font?.fontName)!, size: 12)
        mileageValueLabel.text = rating["t_mileage"] as! String!
        subview.addSubview(mileageValueLabel)
        
        let ratingLabel = UILabel(frame: CGRectMake(10, 120, 100, 30))
        ratingLabel.textAlignment = NSTextAlignment.Left
        ratingLabel.textColor = UIColor.blackColor()
        ratingLabel.font = UIFont(name: (ratingLabel.font?.fontName)!, size: 12)
        ratingLabel.text = "Barelabor Rating"
        subview.addSubview(ratingLabel)
        
        let ratingValueLabel = UILabel(frame: CGRectMake(110, 120, 100, 30))
        ratingValueLabel.textAlignment = NSTextAlignment.Right
        ratingValueLabel.textColor = UIColor.blackColor()
        ratingValueLabel.text = rating["t_rating"] as! String!
        ratingValueLabel.font = UIFont(name: (ratingValueLabel.font?.fontName)!, size: 12)
        subview.addSubview(ratingValueLabel)
        
        let tireRatingLabel = UILabel(frame: CGRectMake(10, 150, 100, 30))
        tireRatingLabel.textAlignment = NSTextAlignment.Left
        tireRatingLabel.textColor = UIColor.blackColor()
        tireRatingLabel.font = UIFont(name: (tireRatingLabel.font?.fontName)!, size: 12)
        tireRatingLabel.text = "Tire Ranking"
        subview.addSubview(tireRatingLabel)
        
        let tireRatingValueLabel = UILabel(frame: CGRectMake(110, 150, 100, 30))
        tireRatingValueLabel.textAlignment = NSTextAlignment.Right
        tireRatingValueLabel.textColor = UIColor.blackColor()
        let t_rating = (rating["t_rating"] as! NSString!).doubleValue
        tireRatingValueLabel.font = UIFont(name: (tireRatingValueLabel.font?.fontName)!, size: 12)
        tireRatingValueLabel.text = t_rating > 7.56 ? "Above Average" : "Below Average"
        subview.addSubview(tireRatingValueLabel)
        
        alert.addButton("Buy Now", action: {
            let actionSheetController = UIAlertController(title: "Select Option", message: "Where would you like to shop at?", preferredStyle: .ActionSheet)
            
            let tirerackAction = UIAlertAction(title: "Tirerack", style: .Default, handler: { action -> Void in
                if let tirerackUrl = NSURL(string: "http://www.anrdoezrs.net/click-8048474-10399938-1431633665000"){
                    if (UIApplication.sharedApplication().openURL(tirerackUrl)){
                        print("successfully opened")
                    }
                }
                else{
                    print("invalid url")
                }
            })
            actionSheetController.addAction(tirerackAction)
            
            let firestoneAction = UIAlertAction(title: "Firestone", style: .Default, handler: { action -> Void in
                if let tirerackUrl = NSURL(string: "http://www.dpbolvw.net/click-8048474-11275445-1408120810000"){
                    if (UIApplication.sharedApplication().openURL(tirerackUrl)){
                        print("successfully opened")
                    }
                }
                else{
                    print("invalid url")
                }
            })
            actionSheetController.addAction(firestoneAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            })
            actionSheetController.addAction(cancelAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        })
        alert.customSubview = subview
        alert.showInfo("Tire Information", subTitle: "", closeButtonTitle: "Close")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    /*
    @IBAction func didToggleButtonPressed(sender: UIButton){
        if let tag = ToggleButtons(rawValue: sender.tag){
            self.masterButton.backgroundColor = UIColor.clearColor()
            self.advancedButton.backgroundColor = UIColor.clearColor()
            self.intermediateButton.backgroundColor = UIColor.clearColor()
            self.begginerButton.backgroundColor = UIColor.clearColor()
            
            sender.backgroundColor = UIColor(red: 16/255.0, green: 56/255.0, blue: 125/255.0, alpha: 1)
            
            switch tag {
            case .Master:
                debugPrint("Master")
            case .Advanced:
                debugPrint("Advanced")
            case .Intermediate:
                debugPrint("Intermediate")
            case .Begginer:
                debugPrint("Begginer")
            }
        }
    }
    */
    
    @IBAction func didPressNotMyCarButton(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Private Methods
    
    private func sortPrices(prices: [String]) {
        
        var intPrices: [Int] = []
        
        for price in prices {
            intPrices.append((price as NSString).integerValue)
        }
        
        intPrices.sortInPlace(<)
        
        let lowValue = intPrices[0]
        let higherValue = intPrices.last
        
        var totalPrice = 0
        
        for price in intPrices {
            totalPrice += price
        }
        
        let avarageValue = totalPrice / intPrices.count
        
        self.lowPriceLabel.text =  "$\(lowValue)"
        self.highPriceLabel.text = "$\(higherValue!)"
        self.AvaragePriceLabel.text = "$\(avarageValue)"
        
        // Remove all prices feidl
        self.prices.removeAll()
    }
    
    @IBAction func didPressButton(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
