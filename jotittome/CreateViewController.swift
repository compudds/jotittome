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
        
        func displayAlert(_ title:String, error:String) {
            
            let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
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
        
        @IBAction func toggleSignUp(_ sender: AnyObject) {
            
            self.performSegue(withIdentifier: "createToLogin", sender: self)
        
        }
        
        @IBAction func signUp(_ sender: AnyObject) {
            
            var error = ""
            
            
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                if #available(iOS 13.0, *) {
                    activityIndicator.style = UIActivityIndicatorView.Style.medium
                } else {
                    activityIndicator.style = UIActivityIndicatorView.Style.gray
                }
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                if username.text == "" || password.text == "" || emailaddress.text == "" || mobilePhone.text == "" || cellCarrier.text == ""{
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    error = "Please enter all fields."
                    
                    displayAlert("Error In Form: ", error: error)
                    
                  } else {
                    
                    if cellCarrier.text == "" {
                        
                        error = "Please pick a cell phone carrier. All text numbers need a carrier attach to the number."
                        
                        displayAlert("Error: ", error: error)
                        
                    } else {
                        
                        let cleanNumber = mobilePhone.text
                        clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                        
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
                        user.signUpInBackground {
                            (succeeded, signupError) in
                            
                            self.activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                            if signupError == nil  {
                                // Hooray! Let them use the app now.
                                
                                print("\(String(describing: PFUser.current()!.username)) signed up")
                                
                                self.performSegue(withIdentifier: "loginToMessage", sender: self)
                                
                            } else {
                                if signupError != nil {
                                    
                                    error = signupError as! String
                                    
                                } else {
                                    
                                    error = "Please try again later."
                                    
                                }
                                
                                self.displayAlert("Could Not Sign Up", error: error)
                                
                            }
                        
                        
                    }
                    
                    
                    }
                    
                }
    
        }
    
       var pickerDataSource = ["Alltel", "AT&T", "Boost", "Cricket", "Metro PCS", "O2", "Orange", "Republic", "Rogers", "Sprint PCS", "T-Mobile", "US Cellular", "Verizon", "Virgin", "Quest"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            clean = ""
            self.carrierPicker.dataSource = self
            self.carrierPicker.delegate = self
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
    
        override func viewDidAppear(_ animated: Bool) {
            
            if PFUser.current() != nil {
                
                userEmail = PFUser.current()!.email!
                print(userEmail)
                userText = PFUser.current()!["mobilePhoneCarrier"]! as! String
                print(userText)
                self.performSegue(withIdentifier: "loginToMessage", sender: self)
                
            }
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // username.resignFirstResponder()
            return true
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden = false
        }

}

