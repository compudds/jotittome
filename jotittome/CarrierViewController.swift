//
//  CarrierViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/3/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import WebKit

var carrierSMS = String()
var carrierMMS = String()
var smsNumber = String()
var mmsNumber = String()
var clean = String()

class CarrierViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var namePicked = ""
    
    @IBOutlet var pickedName: UITextField!
    
    @IBOutlet var carrierTypeLabel: UILabel!
    
    //@IBOutlet var carrierNameLabel: UILabel!
    
    @IBOutlet var containerView: WKWebView!
    
    @IBAction func carrierLookup(_ sender: Any) {
        
        if clean.first == "1" {
            
            clean = String(clean.dropFirst(1))
        }
        
        let url1 = "http://www.carrierlookup.com/index.php/api/lookup?key=d5498e618b4a65ffa2bec3f700c7b02c71ae7d99&number=" + clean
 
        let carrierLookupURL: URL = URL(string: url1)!
        
        let request: URLRequest = URLRequest(url: carrierLookupURL)
        
        print(carrierLookupURL)
        
        containerView!.load(request)
        
        let data = try? Data(contentsOf: URL(string: url1)!)
        
        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        
        if let objects = json as? [String: Any] {
            
            if let responses = objects["Response"] as? [String:Any] {
                
                if let carrierType = responses["carrier_type"] as? String {
                    
                   if let carrierName = responses["carrier"] as? String {
                        
                        if carrierType == "mobile" {
                            
                            carrierTypeLabel.text = "The phone number \(clean) is a \(carrierType.capitalized) phone, the carrier is \( carrierName.capitalized)."
                        } else {
                            
                            carrierTypeLabel.text = "The phone number \(clean) is a \(carrierType.capitalized)."
                        }
                       
                    }
                        
                }
                
            }
            
        }
        
    }
    
    @IBAction func doneBnt(_ sender: UIButton) {
        
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
        
        if (self.namePicked == "Republic"){
            
            carrierSMS = "\(clean)" + "@text.republicwireless.com"
            carrierMMS = "\(clean)" + "@text.republicwireless.com"
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
        
        //self.performSegue(withIdentifier: "carrierToText", sender: self)
        
        self.performSegue(withIdentifier: "carrierToMessages", sender: self)
    }

    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Republic", "Rogers", "Sprint PCS", "T-Mobile", "US Cellular", "Verizon", "Virgin", "Quest"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
