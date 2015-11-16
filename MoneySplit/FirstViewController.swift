//
//  FirstViewController.swift
//  MoneySplit
//
//  Created by Aiqi Liu on 9/21/15.
//  Copyright (c) 2015 Aiqi Liu. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var toPass : basicInfo!
    var info  = basicInfo()
    var buyer = PFObject(className: "Buyer")
    var allBuyer: [String] = []
    var selectedBuyer = ""
    var totalCount = 0
    //details for the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print ("call function 1")
        let query = PFQuery(className: "Buyer")
        var totalCount = 0
        
        totalCount = self.allBuyer.count
        print(totalCount)
        return totalCount
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        print ("call function 2")
        
        
        return allBuyer[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print ("call function 3")
        selectedBuyer = allBuyer[row]
        info.selectedBuyer = allBuyer[row]
        //rowIndex = row
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        inputSaved.hidden = true
        self.namePicker.delegate = self
        self.namePicker.dataSource = self
        let tbvc = self.tabBarController  as! myTabBarController
        info = tbvc.toPass
        let newSplited =  [Double](count:Int(info.numPar), repeatedValue: 0.0)
        info.splited += newSplited
        
        let query = PFQuery(className: "Buyer")
        query.selectKeys(["Name"])
        
        
        var objects :[PFObject]
        do{
            objects = try query.findObjects() as [PFObject]
            for object in objects{
                print(object["Name"])
                self.allBuyer.append(object["Name"] as! String)
            }
        }catch{
            print(error)
        }
       
        
        /*query.findObjectsInBackgroundWithBlock {
            (objects, error )  in
            if (error == nil ){
                print ("success")
                for object in objects!{
                    print(object["Name"])
                    self.allBuyer.append(object["Name"] as! String)
                }
                
            }else{
                print(error)
            }
        }
        */

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var namePicker: UIPickerView!
    @IBOutlet var itemCost: UITextField!
    @IBOutlet var inputSaved: UIView!
    
       @IBAction func action(sender: AnyObject) {
        let cost : Double = (itemCost.text! as NSString).doubleValue
        let mean : Double = cost/info.numPar
        
        let query = PFQuery(className: "Buyer")
        query.whereKey("Name", equalTo: selectedBuyer)
        let buyerArr = query.findObjects
        print(buyerArr)
        //accumulate the amount of money owed to that buyer
        //make attributed strings
        if (buyer["Identity"] as! String != "me") {
            
            info.splited[info.rowIndex - 1] += -mean
            query.whereKey("Identity", equalTo: "me")
//            let money = query.findObjects()
//            money["splited"] = -mean
//            
            
            let substringCnt:Int = (info.otherNames[info.rowIndex-1] as NSString).length + 3
            
            info.display[info.rowIndex - 1] = String((info.display[info.rowIndex - 1] as NSString).substringToIndex(substringCnt))+(String(format:"%.1f", info.splited[info.rowIndex - 1]))
        } else {
            //"I" paid money, update the amount to all other participants
            for(var i = 0; i < (Int)(info.numPar-1); i++){
                info.splited[i] += +mean
                let substringCnt:Int = (info.otherNames[i] as NSString).length + 3
                
                info.display[i] = String((info.display[i] as NSString).substringToIndex(substringCnt))+(String(format:"%.1f", info.splited[i]))

            }
        }
            //append the money amount to each display string
        
                
        
        //popup window if no cost is entered
        if (cost == 0) {
            let alertController = UIAlertController(title: "Ooops!", message:
                "Please fill in the cost", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if(cost != 0){
            inputSaved.hidden = false
            inputSaved.alpha = 1.0
            var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
        }
        //reset picker*******curently doesnt REOLOAD!
        namePicker.reloadAllComponents()
        //clear textField
        itemCost.text = ""
        //keyboard goes away after clciking on button
        self.itemCost.resignFirstResponder()
        
        
        }
    
    func update() {
        //  PopUpView.hidden = true
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.inputSaved.alpha = 0.0
            }, completion: nil)
        
    }
    
    //click the blank area. keyboard goes away
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches,  withEvent: event)
    }
}

