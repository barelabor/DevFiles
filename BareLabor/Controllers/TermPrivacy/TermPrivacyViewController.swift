//
//  TermPrivacyViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class TermPrivacyViewController: UIViewController {

    @IBOutlet weak var textView : UITextView?
    var showContent : SettingsButtonTags!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title and show
        self.navigationItem.title = "Need A Tire"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBarHidden = false
        if let item = SettingsButtonTags(rawValue: self.showContent.rawValue){
            
            var path = ""
            let bundle = NSBundle.mainBundle()
            switch item {
            case .PrivacyPolicy :
                self.navigationItem.title = "Privacy Policy"
                path = bundle.pathForResource("Privacy Policy", ofType: "txt")!
                do {
                    let strPrivacy = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as NSString
                    
                    let fontSize : CGFloat = 14.0
                    let subAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(fontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
                    let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(fontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
                    let attributedString = NSMutableAttributedString(string: strPrivacy as String, attributes: attrs )
                    
                    
                    let range : NSRange = strPrivacy.rangeOfString("Third party applications")
                    let range1 : NSRange = strPrivacy.rangeOfString("Location data")
                    
                    
                    attributedString.addAttributes(subAttrs, range: range)
                    attributedString.addAttributes(subAttrs, range: range1)
                    
                    self.textView?.attributedText = attributedString
                }
                catch {/* error handling here */}
            case .TermOfUse :
                do {
                    self.navigationItem.title = "Term Of Use"
                    path = bundle.pathForResource("Term of use", ofType: "txt")!
                    let strPrivacy = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as NSString
                    
                    let fontSize : CGFloat = 14.0
                    let subAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(fontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
                    let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(fontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
                    let attributedString = NSMutableAttributedString(string: strPrivacy as String, attributes: attrs )
                    
                    
                    let range : NSRange = strPrivacy.rangeOfString("Effective Date: May 28, 2015")
                    let range1 : NSRange = strPrivacy.rangeOfString("1. Your relationship with BareLabor")
                    let range2 : NSRange = strPrivacy.rangeOfString("2. Accepting this Agreement")
                    let range3 : NSRange = strPrivacy.rangeOfString("3. Provision of the Services by BareLabor")
                    let range4 : NSRange = strPrivacy.rangeOfString("4. Use of the Services by you")
                    let range5 : NSRange = strPrivacy.rangeOfString("5. Your passwords and account security")
                    let range6 : NSRange = strPrivacy.rangeOfString("6. Privacy and your personal information")
                    let range7 : NSRange = strPrivacy.rangeOfString("7. Content in the Services")
                    let range8 : NSRange = strPrivacy.rangeOfString("8. BareLabor Pic Your Price")
                    let range9 : NSRange = strPrivacy.rangeOfString("Step 1: Where Will You be Coming from?")
                    let range10 : NSRange = strPrivacy.rangeOfString("Step 2: What Vehicle Needs to be Serviced?")
                    let range11 : NSRange = strPrivacy.rangeOfString("Step 3: Do You Know What Service You Need?")
                    let range12 : NSRange = strPrivacy.rangeOfString("9. BareLabor Pic Your Price Service")
                    let range13 : NSRange = strPrivacy.rangeOfString("10. Proprietary rights")
                    let range14 : NSRange = strPrivacy.rangeOfString("11. Content license from you")
                    let range15 : NSRange = strPrivacy.rangeOfString("12. Termination by BareLabor")
                    let range16 : NSRange = strPrivacy.rangeOfString("13. EXCLUSION OF WARRANTIES")
                    let range17 : NSRange = strPrivacy.rangeOfString("14. LIMITATION OF LIABILITY")
                    let range18 : NSRange = strPrivacy.rangeOfString("15. Indemnification")
                    let range19 : NSRange = strPrivacy.rangeOfString("16. Dispute Resolution and Class Action Waiver")
                    let range20 : NSRange = strPrivacy.rangeOfString("17. Copyright policies")
                    let range21 : NSRange = strPrivacy.rangeOfString("18. Advertisements")
                    let range22 : NSRange = strPrivacy.rangeOfString("19. Other content")
                    let range23 : NSRange = strPrivacy.rangeOfString("20. Changes to this Agreement")
                    let range24 : NSRange = strPrivacy.rangeOfString("21. General legal terms")
                    
                    attributedString.addAttributes(subAttrs, range: range)
                    attributedString.addAttributes(subAttrs, range: range1)
                    attributedString.addAttributes(subAttrs, range: range2)
                    attributedString.addAttributes(subAttrs, range: range3)
                    attributedString.addAttributes(subAttrs, range: range4)
                    attributedString.addAttributes(subAttrs, range: range5)
                    attributedString.addAttributes(subAttrs, range: range6)
                    attributedString.addAttributes(subAttrs, range: range7)
                    attributedString.addAttributes(subAttrs, range: range8)
                    attributedString.addAttributes(subAttrs, range: range9)
                    attributedString.addAttributes(subAttrs, range: range10)
                    attributedString.addAttributes(subAttrs, range: range11)
                    attributedString.addAttributes(subAttrs, range: range12)
                    attributedString.addAttributes(subAttrs, range: range13)
                    attributedString.addAttributes(subAttrs, range: range14)
                    attributedString.addAttributes(subAttrs, range: range15)
                    attributedString.addAttributes(subAttrs, range: range16)
                    attributedString.addAttributes(subAttrs, range: range17)
                    attributedString.addAttributes(subAttrs, range: range18)
                    attributedString.addAttributes(subAttrs, range: range19)
                    attributedString.addAttributes(subAttrs, range: range20)
                    attributedString.addAttributes(subAttrs, range: range21)
                    attributedString.addAttributes(subAttrs, range: range22)
                    attributedString.addAttributes(subAttrs, range: range23)
                    attributedString.addAttributes(subAttrs, range: range24)
                    
                    
                    self.textView?.attributedText = attributedString
            }
            catch {/* error handling here */}
            default :
                debugPrint("TermOfUse")
            }
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
