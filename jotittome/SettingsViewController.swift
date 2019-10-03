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
    
    func displayAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBOutlet var updateSettings: UILabel!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var emailaddress: UITextField!
    
    @IBOutlet var mobilePhone: UITextField!
    
    @IBOutlet var cellCarrier: UITextField!
    
    @IBOutlet var carrierPicker: UIPickerView!
    
    @IBAction func update(_ sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if username.text == "" || emailaddress.text == "" || mobilePhone.text == "" || cellCarrier.text == ""{
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            error = "Please enter all fields."
            
            displayAlert("Error In Form: ", error: error)
            
        } else {
            
            let user = PFUser.current()
            
            if user != nil {
                
                user!.username = self.username.text
                user!.email = self.emailaddress.text
                userEmail = self.emailaddress.text! + ","
                // other fields can be set just like with PFObject
                let cleanNumber = mobilePhone.text
                clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                
                print(clean)
                
                assignCarrier()
                
                user!["mobilePhone"]! = clean
                user!["carrier"]! = self.cellCarrier.text as AnyObject
                user!["mobilePhoneCarrier"]! = clean + carrierSMS
                userText = clean + carrierSMS + ","
                user!.saveEventually()
                print(user!.username!)
                print(user!.email!)
                print(user!["mobilePhone"]!)
                print(user!["carrier"]!)
                print(user!["mobilePhoneCarrier"]!)
                
            } else {
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                let alert = UIAlertController(title: "Error Updating!", message: "Please log out and log back in, thentry updating again.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Log Out?", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    self.logOut()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            //updateSettings.text = "Your settings have been saved."
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Thank You!", message: "Your settings have been saved.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.username.text = ""
                self.emailaddress.text = ""
                self.emailaddress.text = ""
                self.mobilePhone.text = ""
                self.cellCarrier.text = ""
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func backToMessages(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "settingsToMessages", sender: self)
        
    }
    @IBAction func contactUs(_ sender: AnyObject) {
        
        contactUs()
        
    }

    var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Republic", "Rogers", "Sprint PCS", "T-Mobile", "US Cellular", "Verizon", "Virgin", "Quest"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        clean = ""
        self.carrierPicker.dataSource = self
        self.carrierPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.navigationController?.navigationBarHidden = true
        noInternetConnection()
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
        if (self.namePicked == "Republic"){
            
            carrierSMS = "@text.republicwireless.com"
            carrierMMS = "@text.republicwireless.com"
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
        
        let alert = UIAlertController(title: "Contact Us", message: "Email or rate us.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.sendEmail()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Rate Us", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.rateUs()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Home", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "settingsToMessages", sender: self)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sendEmail() {
        
        let toRecipents = ["jotittome@bettersearchllc.com"]
        print(toRecipents)
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func rateUs() {
        
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id668352073") {
            UIApplication.shared.open(url, options: [:])
        }
        
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
        self.performSegue(withIdentifier: "settingsToLogIn", sender: self)
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Jot-It To Me requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
