//
//  SettingsViewController.swift
//  jotittome
//
//  Created by Eric Cook on 6/16/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var namePicked = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    @IBOutlet var updateSettings: UILabel!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var emailaddress: UITextField!
    
    @IBOutlet var mobilePhone: UITextField!
    
    @IBOutlet var cellCarrier: UITextField!
    
    @IBOutlet var carrierPicker: UIPickerView!
    
    @IBAction func update(sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if username.text == "" || emailaddress.text == "" || mobilePhone.text == "" || cellCarrier.text == ""{
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            error = "Please enter all fields."
            
            displayAlert("Error In Form: ", error: error)
            
        } else {
            
            let user = PFUser.currentUser()
            
            if user != nil {
                
                user!.username = self.username.text
                user!.email = self.emailaddress.text
                userEmail = self.emailaddress.text! + ","
                // other fields can be set just like with PFObject
                let cleanNumber = mobilePhone.text
                clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                
                print(clean)
                
                assignCarrier()
                
                user!["mobilePhone"]! = clean
                user!["carrier"]! = self.cellCarrier.text as AnyObject!
                user!["mobilePhoneCarrier"]! = clean + carrierSMS
                userText = clean + carrierSMS + ","
                user!.saveEventually()
                print(user!.username)
                print(user!.email)
                print(user!["mobilePhone"]!)
                print(user!["carrier"]!)
                print(user!["mobilePhoneCarrier"]!)
                
            } else {
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                let alert = UIAlertController(title: "Error Updating!", message: "Please log out and log back in, thentry updating again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Log Out?", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.logOut()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            //updateSettings.text = "Your settings have been saved."
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Thank You!", message: "Your settings have been saved.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.username.text = ""
                self.emailaddress.text = ""
                self.emailaddress.text = ""
                self.mobilePhone.text = ""
                self.cellCarrier.text = ""
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func backToMessages(sender: AnyObject) {
        
        self.performSegueWithIdentifier("settingsToMessages", sender: self)
        
    }
    @IBAction func contactUs(sender: AnyObject) {
        
        contactUs()
        
    }

    var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Pinger", "Rogers", "Sprint PCS", "T-Mobile", "Text Free", "US Cellular", "Verizon", "Virgin", "Quest"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        clean = ""
        self.carrierPicker.dataSource = self
        self.carrierPicker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //self.navigationController?.navigationBarHidden = true
        noInternetConnection()
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
    
    func contactUs(){
        
        let alert = UIAlertController(title: "Contact Us", message: "Email or rate us.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Email", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.sendEmail()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Rate Us", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.rateUs()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Home", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegueWithIdentifier("settingsToMessages", sender: self)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func sendEmail() {
        
        let toRecipents = ["jotittome@bettersearchllc.com"]
        print(toRecipents)
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rateUs() {
        
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id668352073")!);
        
    }
    
    func logOut(){
        
        smsNumber = ""
        mmsNumber = ""
        clean = ""
        message = ""
        emailAddressesSelected = ""
        selectedDate = ""
        selectedTime = ""
        //messageText.text = ""
        period = ""
        num = ""
        freq = ""
        //schedDateTime.datePickerMode = UIDatePickerMode.DateAndTime
        //keyboardInactive()
        pastReminders = []
        todayReminders = []
        futureReminders = []
        parseUser = ""
        emailActive = 0
        textActive = 0
        defaultEmailActive = 0
        defaultTextActive = 0
        //defaultColors()
        btnColor = ""
        
        PFUser.logOut()
        userEmail = ""
        //signupActive == true
        self.performSegueWithIdentifier("settingsToLogIn", sender: self)
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Jot-It To Me requires an internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
