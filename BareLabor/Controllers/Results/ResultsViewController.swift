//
//  ResultsViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ResultsViewController: BaseViewController , ResultsSlideViewDelegate {

    @IBOutlet weak var sideMenuTralingConstraint : NSLayoutConstraint!
    @IBOutlet weak var slideMenu : ResultsSlideView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var myCar : UIButton!
    @IBOutlet weak var notMyCar : UIButton!
    @IBOutlet weak var whatThePriceButton : UIButton!
    @IBOutlet weak var findNearestLoctionButton : UIButton!
    @IBOutlet weak var tellUsYourExpirienceButton : UIButton!
    @IBOutlet weak var addAnotherService : UIButton!
    @IBOutlet weak var logoImage : UIImageView!
    
    var buttons : [String] = ["ALL", "BRAKES", "STRUTS", "LIGHTS","ALL", "BRAKES", "STRUTS", "LIGHTS"]
    var offset : CGFloat = 0
    var selectedButton : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.mainScreen().bounds.size.height == 480.0{
            self.logoImage.image = nil
        }
        
        
        self.collectionView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let sideButton = UIButton(frame:CGRectMake(0.0, 0.0, 19.0, 17.0))
        sideButton.setBackgroundImage(UIImage(named: "SideMenuImage"), forState: UIControlState.Normal)
        sideButton.addTarget(self, action: #selector(ResultsViewController.showSideMenu(_:)), forControlEvents: .TouchUpInside)
       
        self.notMyCar.layer.borderColor = UIColor.whiteColor().CGColor
        self.whatThePriceButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.findNearestLoctionButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.tellUsYourExpirienceButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.addAnotherService.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:sideButton )
        
        self.navigationItem.title = "Results"
        
        self.slideMenu.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.calculateOffsetForCollectionItems(self.buttons)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int{
            return self.buttons.count;
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Identifier", forIndexPath: indexPath) as! ButtonsCollectionViewCell
            
            cell.title.text = self.buttons[indexPath.row]
            cell.title.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor(red: 30/255.0, green: 104/255.0, blue: 229/255.0, alpha: 1)
            
            if self.selectedButton == indexPath.row{
                cell.title.textColor = UIColor(red: 30/255.0, green: 104/255.0, blue: 229/255.0, alpha: 1)
                cell.backgroundColor = UIColor.whiteColor()
            }
            
            
            return cell
    }
    
    func collectionView( collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let string = self.buttons[indexPath.row] as String
        let myString = NSString(string: string)
        let width = myString.boundingRectWithSize(CGSizeMake(CGFloat.max, self.collectionView.frame.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14.0)], context: nil).width
        
        let size = CGSizeMake(round(width) + 20 + CGFloat(self.offset), self.collectionView.frame.size.height)
        return size
    }
    
    func collectionView( collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        self.selectedButton = indexPath.row
        collectionView.reloadData()
    }
    
    private func calculateOffsetForCollectionItems(array: [String]){
        
        for string in array{
            let myString = NSString(string: string)
            let width = myString.boundingRectWithSize(CGSizeMake(CGFloat.max, self.collectionView.frame.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14.0)], context: nil).width
                self.offset += round(width) + 20.0 + 2.0
        }
        if self.offset < self.collectionView.bounds.size.width{
            self.offset = (self.collectionView.bounds.size.width - self.offset) / CGFloat(self.buttons.count)
        }else{
            self.offset = 0.0
        }
        self.collectionView.reloadData()
    }
    
    //MARK: - Private methods
    
    func showSideMenu(sender: UIButton?){
        self.slideMenu.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if self.sideMenuTralingConstraint.constant == 0{
                self.sideMenuTralingConstraint.constant = -270
                
            }
            else{
                self.sideMenuTralingConstraint.constant = 0
                
            }
            self.view.layoutSubviews()
            },completion: { (finished: Bool) -> Void in
                self.slideMenu.hidden = self.sideMenuTralingConstraint.constant != 0
                
        });
    }
    
    func resultsSlideDidSelectItem(item: ResultsSlideItem){
        self.showSideMenu(nil)
        switch item {
        case .NewSearch:
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))
                ), dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        case .Settings:
            self.performSegueWithIdentifier(ShowSegue.Results.Settings.rawValue, sender: nil)
        }
    }

    //MARK: - IBActions
    
    @IBAction func didCahngeSegment(sender: UISegmentedControl) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowSegue.Results.Settings.rawValue{
            
        }
    }
    

}
