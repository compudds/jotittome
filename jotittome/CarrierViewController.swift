//
//  CarrierViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/3/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit

var carrierSMS = String()
var carrierMMS = String()
var smsNumber = String()
var mmsNumber = String()
var clean = String()

class CarrierViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var namePicked = ""
    
    @IBOutlet var pickedName: UITextField!
    
    @IBAction func doneBnt(sender: UIButton) {
        
        if (self.namePicked == "Alltel"){
            
            carrierSMS = "\(clean)" + "@sms.alltelwireless.com"
            carrierMMS = "\(clean)" + "@mms.alltelwireless.com"
        }
        if (self.namePicked == "AT&T"){
            
            carrierSMS = "\(clean)" + "@txt.att.net"
            carrierMMS = "\(clean)" + "@mms.att.net"
        }
        if (self.namePicked == "Boost"){
            
            carrierSMS = "\(clean)" + "@sms.myboostmobile.com"
            carrierMMS = "\(clean)" + "@myboostmobile.com"
        }
        if (self.namePicked == "Cricket"){
            
            carrierSMS = "\(clean)" + "@sms.mycricket.com"
            carrierMMS = "\(clean)" + "@mms.mycricket.com"
        }
        if (self.namePicked == "Metro PCS"){
            
            carrierSMS = "\(clean)" + "@mymetropcs.com"
            carrierMMS = "\(clean)" + "@mymetropcs.com"
        }
        if (self.namePicked == "O2"){
            
            carrierSMS = "\(clean)" + "@o2.co.uk"
            carrierMMS = "\(clean)" + "@o2.co.uk"
        }
        if (self.namePicked == "Orange"){
            
            carrierSMS = "\(clean)" + "@orange.net"
            carrierMMS = "\(clean)" + "@orange.net"
        }
        if (self.namePicked == "Pinger"){
            
            carrierSMS = "\(clean)" + "@mobile.pinger.com"
            carrierMMS = "\(clean)" + "@mobile.pinger.com"
        }
        if (self.namePicked == "Rogers"){
            
            carrierSMS = "\(clean)" + "@sms.rogers.com"
            carrierMMS = "\(clean)" + "@mms.rogers.com"
        }
        if (self.namePicked == "Sprint PCS"){
            
            carrierSMS = "\(clean)" + "@messaging.sprintpcs.com"
            carrierMMS = "\(clean)" + "@pm.sprint.com"
        }
        if (self.namePicked == "T-Mobile"){
            
            carrierSMS = "\(clean)" + "@tmomail.net"
            carrierMMS = "\(clean)" + "@tmomail.net"
        }
        if (self.namePicked == "Text Free"){
            
            carrierSMS = "\(clean)" + "@textfree.us"
            carrierMMS = "\(clean)" + "@textfree.us"
        }
        if (self.namePicked == "US Cellular"){
            
            carrierSMS = "\(clean)" + "@email.uscc.net"
            carrierMMS = "\(clean)" + "@mms.uscc.net"
        }
        if (self.namePicked == "Verizon"){
            
            carrierSMS = "\(clean)" + "@vtext.com"
            carrierMMS = "\(clean)" + "@vzwpix.com"
        }
        if (self.namePicked == "Virgin"){
            
            carrierSMS = "\(clean)" + "@vmobl.com"
            carrierMMS = "\(clean)" + "@vmpix.com"
        }
        if (self.namePicked == "Quest"){
            
            carrierSMS = "\(clean)" + "@qwestmp.com"
            carrierMMS = "\(clean)" + "@qwestmp.com"
        }
        
        print(carrierSMS)
        print(carrierMMS)
        
        smsNumber = carrierSMS + "," + smsNumber
        mmsNumber = carrierMMS + "," + mmsNumber
        
        self.performSegueWithIdentifier("carrierToText", sender: self)
    }

    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Pinger", "Rogers", "Sprint PCS", "T-Mobile", "Text Free", "US Cellular", "Verizon", "Virgin", "Quest"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.namePicked = pickerDataSource[row]
        print(pickerDataSource[row])
        pickedName.text = pickerDataSource[row]
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
