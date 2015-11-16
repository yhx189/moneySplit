//
//  InitViewController.swift
//  MoneySplit
//
//  Created by Yang Hu on 9/27/15.
//  Copyright © 2015 Aiqi Liu. All rights reserved.
//

import Foundation
import UIKit
import Parse

class InitViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.hidden = true
//        let testObject = PFObject(className: "Item")
//        testObject["Name"] = "Yang Hu"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
       // }
    }

    var info = basicInfo()
    var counter = 0

    @IBOutlet var popUp: UIView!
    @IBOutlet weak var getName: UITextField!


    @IBOutlet var myName: UITextField!
    @IBAction func enterName(sender: UIButton) {
//        var counter = PFObject(className: "Count")
//        counter["num"] = 0
//        counter.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                print("num saved")
//            }
//        }
//        var query = PFQuery(className: "Count")
//        query.findObjectsInBackground(){
//            (objects: [PFObject]?, error: NSError?) -> Void in
//        }
//
//        if info.myName == [] && myName.text != ""{
//            info.myName.append(myName.text!)
//            
//        }
//        info.otherNames.append(getName.text!)
//        info.numPar += 1
        
       
        if(counter == 0 && myName.text != ""){
            let buyer = PFObject(className:"Buyer")
            buyer["Name"] = myName.text!
            buyer["Identity"] = "me"
            buyer["splited"] = 0
            buyer.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
               if (success) {
                    print("I have been saved")
                }
            }
            counter++;
        }
        
        let buyer = PFObject(className:"Buyer")
        buyer["Name"] = getName.text!
        buyer["Identity"] = "others"
        buyer["splited"] = 0
        buyer.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Other users have been saved")
            }
        }

//        var query = PFQuery(className: "Buyer")
//        query.whereKey("Me", equalTo: myName.text!)
//        query.whereKey("Name", equalTo: getName.text!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                let testObject = PFObject(className: "Buyers")
//                testObject["Name"] = self.getName.text!
//                testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                    print("Object has been saved.")}
//            
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
        
        info.display.append(getName.text! + ": $")
        popUp.hidden = false
        
        popUp.alpha = 1.0
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
        
        //keyboard goes away after clciking on button
        self.getName.resignFirstResponder()
        getName.text = ""

    }
    
    func update() {
        //  PopUpView.hidden = true
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.popUp.alpha = 0.0
            }, completion: nil)
        
    }

    
    /*
override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
*/
    
    //click the blank area. keyboard goes away
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches,  withEvent: event)
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            let svc = segue!.destinationViewController as! myTabBarController
            
            svc.toPass = info
            
            
        }
    }
    
}