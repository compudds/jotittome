//
//  LogInViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/13/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var signupActive = Bool()
var userEmail = String()
var userText = String()

class CreateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var cellCarrier: UITextField!
    
    @IBOutlet var carrierPicker: UIPickerView!
    
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        func displayAlert(title:String, error:String) {
            
            let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    
        var namePicked = ""
        
        @IBOutlet var username: UITextField!
        
        @IBOutlet var password: UITextField!
        
        @IBOutlet var emailaddress: UITextField!
    
        @IBOutlet var mobilePhone: UITextField!
        
        @IBOutlet var alreadyRegistered: UILabel!
        
        @IBOutlet var signUpButton: UIButton!
        
        @IBOutlet var signUpLabel: UILabel!
        
        @IBOutlet var signUpToggleButton: UIButton!
        
        @IBAction func toggleSignUp(sender: AnyObject) {
            
            self.performSegueWithIdentifier("createToLogin", sender: self)
        
        }
        
        @IBAction func signUp(sender: AnyObject) {
            
            var error = ""
            
            
                activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                if username.text == "" || password.text == "" || emailaddress.text == "" || mobilePhone.text == "" || cellCarrier.text == ""{
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    error = "Please enter all fields."
                    
                    displayAlert("Error In Form: ", error: error)
                    
                  } else {
                    
                    let cleanNumber = mobilePhone.text
                    clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                    
                    print(clean)
                    
                    assignCarrier()
                    
                    let user = PFUser()
                    user.username = username.text
                    user.password = password.text
                    user.email = emailaddress.text
                    userEmail = emailaddress.text! + ","
                    // other fields can be set just like with PFObject
                    user["mobilePhone"] = clean
                    user["carrier"] = cellCarrier.text
                    user["mobilePhoneCarrier"] = clean + carrierSMS
                    userText = clean + carrierSMS + ","
                    user.signUpInBackgroundWithBlock {
                        (succeeded, signupError) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if signupError == nil  {
                            // Hooray! Let them use the app now.
                            
                            print("\(PFUser.currentUser()!.username) signed up")
                            
                            self.performSegueWithIdentifier("loginToMessage", sender: self)
                            
                        } else {
                            if let errorString = signupError!.userInfo["error"] as? NSString {
                                
                                error = errorString as String
                                
                            } else {
                                
                                error = "Please try again later."
                                
                            }
                            
                            self.displayAlert("Could Not Sign Up", error: error)
                            
                        }
                    }
                    
                }
    
        }
    
       var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Pinger", "Rogers", "Sprint PCS", "T-Mobile", "Text Free", "US Cellular", "Verizon", "Virgin", "Quest"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            clean = ""
            self.carrierPicker.dataSource = self
            self.carrierPicker.delegate = self
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
        cellCarrier.text = pickerDataSource[row]
    }
    
    func assignCarrier() {
    
    if (self.namePicked == "Alltel"){
    
    carrierSMS = "@sms.alltelwireless.com"
    carrierMMS = "@mms.alltelwireless.com"
    }
    if (self.namePicked == "AT&T"){
    
    carrierSMS = "@txt.att.net"
    carrierMMS = "@mms.att.net"
    }
    if (self.namePicked == "Boost"){
    
    carrierSMS = "@sms.myboostmobile.com"
    carrierMMS = "@myboostmobile.com"
    }
    if (self.namePicked == "Cricket"){
    
    carrierSMS = "@sms.mycricket.com"
    carrierMMS = "@mms.mycricket.com"
    }
    if (self.namePicked == "Metro PCS"){
    
    carrierSMS = "@mymetropcs.com"
    carrierMMS = "@mymetropcs.com"
    }
    if (self.namePicked == "O2"){
    
    carrierSMS = "@o2.co.uk"
    carrierMMS = "@o2.co.uk"
    }
    if (self.namePicked == "Orange"){
    
    carrierSMS = "@orange.net"
    carrierMMS = "@orange.net"
    }
    if (self.namePicked == "Pinger"){
    
    carrierSMS = "@mobile.pinger.com"
    carrierMMS = "@mobile.pinger.com"
    }
    if (self.namePicked == "Rogers"){
    
    carrierSMS = "@sms.rogers.com"
    carrierMMS = "@mms.rogers.com"
    }
    if (self.namePicked == "Sprint PCS"){
    
    carrierSMS = "@messaging.sprintpcs.com"
    carrierMMS = "@pm.sprint.com"
    }
    if (self.namePicked == "T-Mobile"){
    
    carrierSMS = "@tmomail.net"
    carrierMMS = "@tmomail.net"
    }
    if (self.namePicked == "Text Free"){
    
    carrierSMS = "@textfree.us"
    carrierMMS = "@textfree.us"
    }
    if (self.namePicked == "US Cellular"){
            
        carrierSMS = "@email.uscc.net"
        carrierMMS = "@mms.uscc.net"
    }
    if (self.namePicked == "Verizon"){
    
    carrierSMS = "@vtext.com"
    carrierMMS = "@vzwpix.com"
    }
    if (self.namePicked == "Virgin"){
    
    carrierSMS = "@vmobl.com"
    carrierMMS = "@vmpix.com"
    }
    if (self.namePicked == "Quest"){
    
    carrierSMS = "@qwestmp.com"
    carrierMMS = "@qwestmp.com"
    }
    
    print(carrierSMS)
    print(carrierMMS)
    
    //smsNumber = carrierSMS + "," + smsNumber
    //mmsNumber = carrierMMS + "," + mmsNumber
        
    }
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        override func viewDidAppear(animated: Bool) {
            
            if PFUser.currentUser() != nil {
                
                userEmail = PFUser.currentUser()!.email!
                print(userEmail)
                userText = PFUser.currentUser()!["mobilePhoneCarrier"]! as! String
                print(userText)
                self.performSegueWithIdentifier("loginToMessage", sender: self)
                
            }
            
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            // username.resignFirstResponder()
            return true
        }
        
        override func viewWillAppear(animated: Bool) {
            self.navigationController?.navigationBarHidden = true
        }
        
        override func viewWillDisappear(animated: Bool) {
            self.navigationController?.navigationBarHidden = false
        }

}

