//
//  PositiveNegativeViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class PositiveNegativeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var submitButton : UIButton!
    
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var experience : ExperienceType!
    var quiz : NSArray!
    var selectedDictionary : NSMutableDictionary! = NSMutableDictionary()
    
    private var selectedTextfieldFrame: CGRect = CGRectZero
    private var keyboardHeight: CGFloat = 0
    private let commentPlaceholder = "Comments"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // QUESTION AND ANSWERS
        
        self.quiz = [
            ["question" : "1. Were you made to feel welcomed upon arrival?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "2. Did the shop listen to your needs?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "3. Did you feel the advice given was trustworthy?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "4. Was the shop respectful towards your time?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "5. Was the invoice explained to you in full?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "6. Was the repair or service done correctly the first time?", "answers" : ["Yes","No"]],
            ["question" : "7. Are you satisfied with the repair or service?", "answers" : ["Yes","No"]],
            ["question" : "8. Would you recommend the shop to friends or family?", "answers" : ["Yes","No"]]]
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        if let type = ExperienceType(rawValue: self.experience.rawValue){
            switch type {
            case .Positive :
                self.navigationItem.title = "Posititve"
                self.submitButton.backgroundColor = UIColor(red: 9/255.0, green: 177/255.0, blue: 21/255.0, alpha: 1)
            case .Negative :
                self.navigationItem.title = "Negative"
                self.submitButton.backgroundColor = UIColor.redColor()
            }
            self.submitButton.setTitle("SUBMIT", forState: .Normal)
            self.submitButton.setTitle("SUBMIT", forState: .Highlighted)
        }
        
        let textfieldToolbar = UIToolbar(frame: CGRectMake(0, 0, Constants.Size.ScreenWidth.floatValue, 44))
        textfieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "didPressHideKeyboardButton:")]
        
        self.commentTextView.inputAccessoryView = textfieldToolbar
        let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: attributesDictionary)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        self.shopNameTextField.attributedPlaceholder = NSAttributedString(string: "Name of Shop", attributes: attributesDictionary)
        self.commentTextView.placeholderColor = UIColor.whiteColor()
        self.commentTextView.placeholder = self.commentPlaceholder
    }
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PositiveNegativeViewController.onKeyboardFrameChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    
    func didPressHideKeyboardButton(sender: UIBarButtonItem) {
        self.commentTextView.resignFirstResponder()
    }
    
    @IBAction func didPressSubmitButton(sender: UIButton) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var userId = ""
        
        if (nil != defaults.valueForKey("userID")) {
            userId = defaults.valueForKey("userID") as! String
        } else {
            let alert = UIAlertController(title: "Warning", message: "Please Login to App", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let type = String(experience.rawValue)
        let name = nameTextField.text
        let email = emailTextField.text
        let shopName = shopNameTextField.text
        let comments = commentTextView.text
        
        var answers = ""
        var typeAnswers = ["","","","","","","",""]
        var answerType: Int?
        
                for i in 0...7 {
        
                    if (nil != (self.selectedDictionary.valueForKey("\(i)") as? NSIndexPath)) {
        
                        answerType = (self.selectedDictionary.valueForKey("\(i)") as? NSIndexPath)!.row + 1
                        typeAnswers[i] = String(answerType)
                    } else {
                        typeAnswers[i] = "0"
                    }
                }
        
        for type in typeAnswers {
            answers += "\(type),"
        }
        
       answers = answers.substringToIndex(answers.endIndex.predecessor())

        Network.sharedInstance.sumbitExperience(userId, type: type, answers: answers, name: name!, email: email!, shopName: shopName!, comments: comments) { (data) -> Void in
            if (nil != data) {
                let alert = UIAlertController(title: "", message: "Successfully Sent", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Warning", message: "Connection Trouble", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    //MARK: - UITableViewDataSource methods
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuizCell") as! PositiveNegativeTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        cell.customAccessoryView.hidden = false
        cell.customFilledAccessoryView.hidden = true
        
        if((self.selectedDictionary.valueForKey("\(indexPath.section)")) != nil){
            if let item = self.selectedDictionary.valueForKey("\(indexPath.section)") as? NSIndexPath{
                if(item == indexPath){
                    cell.customFilledAccessoryView.hidden = false
                    cell.customAccessoryView.hidden = true
                }
            }
        }
        
        let answers = self.quiz[indexPath.section]["answers"] as! NSArray
        cell.answerLabel.text = answers[indexPath.row] as? String
        
        return cell
    }
    
    func tableView( tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return self.quiz[section]["question"] as? String
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let array = self.quiz[section]["answers"] as! NSArray
        return array.count
    }
    
    func numberOfSectionsInTableView( tableView: UITableView) -> Int{
        return self.quiz.count
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(self.selectedDictionary.count != 0){
            if((self.selectedDictionary.valueForKey("\(indexPath.section)")) != nil){
                if let item = self.selectedDictionary.valueForKey("\(indexPath.section)") as? NSIndexPath{
                    if(item == indexPath){
                        self.selectedDictionary.removeObjectForKey("\(indexPath.section)")
                        
                    }
                    else{
                        self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
                    }
                }
            }
            else{
                self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
                
            }
        }
        else{
            self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.selectedTextfieldFrame = textField.frame
        self.changeTableOffset()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if self.commentPlaceholder == textView.text {
            textView.text = ""
        }
        self.selectedTextfieldFrame = textView.frame
        self.changeTableOffset()
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if "" == textView.text {
            textView.text = self.commentPlaceholder
        }
        return true
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(sender: NSNotification) {
        
        if let userInfo = sender.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if keyboardFrame.origin.y < Constants.Size.ScreenHeight.floatValue {//Keyboard Up
                
                self.tableView.scrollEnabled = false
                self.keyboardHeight = keyboardFrame.size.height
                self.changeTableOffset()
            } else {//Keyboard Down
                
                self.tableView.scrollEnabled = true
                self.keyboardHeight = 0
                self.selectedTextfieldFrame = CGRectZero
                
                let requiredVisibleOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height
                if self.tableView.contentOffset.y > requiredVisibleOffset {
                    self.tableView.setContentOffset(CGPointMake(0, requiredVisibleOffset), animated: true)
                }
            }
        }
    }
    
    private func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableFooter.bounds.size.height + self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.ScreenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight - statusNavigationBarHeight > nonKeyboardHeight {
            self.tableView.setContentOffset(CGPointMake(0, textfieldYHeight + self.tableView.contentOffset.y - nonKeyboardHeight - statusNavigationBarHeight/*textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight*/ + 10), animated: true)
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
