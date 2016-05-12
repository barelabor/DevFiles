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
    
    var pricesForHistoryBtn: [String] = []
    var prices: [String] = []
    var ratingArray: NSArray = []
    var quantity = 1
    // Set default value for low, average, high to display default values if nothing receives.
    static var lowValue = "50"
    static var averageValue = "200"
    static var highValue = "400"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "What’s the Price?"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
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
                button.frame = CGRectMake(perWidth*CGFloat(i+1), chartViewHeight - CGFloat(heightAry[i] as! NSNumber), 9, CGFloat(heightAry[i] as! NSNumber))
                button.backgroundColor = UIColor.whiteColor()
                button.addTarget(self, action: #selector(ChartViewController.barBtnsTapped(_:)), forControlEvents: .TouchUpInside)
                button.tag = ratingArrayCount-i-1
                i = i + 1
                self.chartView.addSubview(button)
            }
        }
    }
    
    func barBtnsTapped(sender: UIButton){
        let index = sender.tag
        let rating = self.ratingArray[index]
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView()
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,220,170))
        
        let nameLabel = UILabel(frame: CGRectMake(10, 10, 80, 50))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.blackColor()
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
        priceLabel.text = "Tire Price"
        subview.addSubview(priceLabel)
        
        let priceValueLabel = UILabel(frame: CGRectMake(110, 60, 100, 30))
        priceValueLabel.textAlignment = NSTextAlignment.Right
        priceValueLabel.textColor = UIColor.blackColor()
        let t_price = rating["t_price"] as! NSString!
        let quantityPrice = CGFloat(t_price.doubleValue) * CGFloat(self.quantity)
        priceValueLabel.text = "\(quantityPrice)"
        subview.addSubview(priceValueLabel)
        
        let mileageLabel = UILabel(frame: CGRectMake(10, 90, 100, 30))
        mileageLabel.textAlignment = NSTextAlignment.Left
        mileageLabel.textColor = UIColor.blackColor()
        mileageLabel.text = "Tire Mileage"
        subview.addSubview(mileageLabel)
        
        let mileageValueLabel = UILabel(frame: CGRectMake(110, 90, 100, 30))
        mileageValueLabel.textAlignment = NSTextAlignment.Right
        mileageValueLabel.textColor = UIColor.blackColor()
        mileageValueLabel.text = rating["t_mileage"] as! String!
        subview.addSubview(mileageValueLabel)
        
        let ratingLabel = UILabel(frame: CGRectMake(10, 120, 100, 30))
        ratingLabel.textAlignment = NSTextAlignment.Left
        ratingLabel.textColor = UIColor.blackColor()
        ratingLabel.text = "Tire Rating"
        subview.addSubview(ratingLabel)
        
        let ratingValueLabel = UILabel(frame: CGRectMake(110, 120, 100, 30))
        ratingValueLabel.textAlignment = NSTextAlignment.Right
        ratingValueLabel.textColor = UIColor.blackColor()
        ratingValueLabel.text = rating["t_rating"] as! String!
        subview.addSubview(ratingValueLabel)
        
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
