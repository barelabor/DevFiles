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
    var pricesForHistoryBtn: [String] = []
    var prices: [String] = []
    var ratingArray: NSArray = []
    var quantity = 1
    // Set default value for low, average, high to display default values if nothing receives.
    static var lowValue = "50"
    static var averageValue = "200"
    static var highValue = "400"
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ratingArrayCount = self.ratingArray.count
        let chartViewHeight = self.chartView.frame.size.height
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let perWidth = screenWidth/CGFloat(ratingArrayCount+1)
        print("chartviewheight", chartViewHeight)
        let heightAry : NSMutableArray=[]
        let firstSize = 100
        for i in 0 ..< ratingArrayCount {
            heightAry.addObject(firstSize + (i * 10))
        }
        
        print(heightAry)
        var i = 0
        if (ratingArrayCount != 0) {
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
        
        let closeBtnImage = UIImage(named: "close_btn.png") as UIImage!
        let button   = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(195, 0, 20, 20)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(closeBtnImage, forState: .Normal)
        button.tintColor = UIColor.clearColor()
        button.imageView?.tintColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(ChartViewController.closePopupBtnTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        subview.addSubview(button)
        
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
        tireRatingLabel.text = "Tire Rating"
        subview.addSubview(tireRatingLabel)
        
        let tireRatingValueLabel = UILabel(frame: CGRectMake(110, 150, 100, 30))
        tireRatingValueLabel.textAlignment = NSTextAlignment.Right
        tireRatingValueLabel.textColor = UIColor.blackColor()
        let t_rating = (rating["t_rating"] as! NSString!).doubleValue
        tireRatingValueLabel.font = UIFont(name: (tireRatingValueLabel.font?.fontName)!, size: 12)
        tireRatingValueLabel.text = t_rating > 7.56 ? "Above Average" : "Below Average"
        subview.addSubview(tireRatingValueLabel)
        
        alert.addButton("Buy Now", action: {
            let actionSheetController = UIAlertController(title: "Select Option", message: "Where would you like to shop it?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> Void in
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            })
            actionSheetController.addAction(cancelAction)
            
            let tirerackAction = UIAlertAction(title: "Tirerack", style: .Default, handler: { action -> Void in
                if let tirerackUrl = NSURL(string: "http://www.dpbolvw.net/click-8048474-11275445-1408120810000"){
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
                if let tirerackUrl = NSURL(string: "http://www.anrdoezrs.net/click-8048474-10399938-1431633665000"){
                    if (UIApplication.sharedApplication().openURL(tirerackUrl)){
                        print("successfully opened")
                    }
                }
                else{
                    print("invalid url")
                }
            })
            actionSheetController.addAction(firestoneAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        })
        alert.customSubview = subview
        alert.showInfo("Tire Information", subTitle: "", closeButtonTitle: "Close")
        
    }
    
    func closePopupBtnTapped(){
        alert.hideView()
        print("123")
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
