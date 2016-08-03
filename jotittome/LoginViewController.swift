//
//  LoginViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/13/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func create(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier("loginToCreate", sender: self)
        
        
    }
    
    
    @IBOutlet var emailPasswordReset: UITextField!
    
    @IBAction func resetPassword(sender: AnyObject) {
        
            self.emailPasswordReset.alpha = 1
            self.loginButton.setTitle("Send", forState: .Normal)
            self.password.alpha = 0
            self.username.alpha = 0

    }
    
    
    @IBAction func loginn(sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if self.emailPasswordReset.alpha == 0 {
        
        if username.text == "" || password.text == "" {
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                error = "Please enter all fields."
                
                displayAlert("Error In Form: ", error: error)
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                    (user, signupError) -> Void in
                    
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        print("\(PFUser.currentUser()!.username) is logged in")
                        userEmail = PFUser.currentUser()!.email! + ","
                        userText = PFUser.currentUser()!["mobilePhoneCarrier"]! as! String + ","
                        print(userText)

                        self.performSegueWithIdentifier("loginToMessage", sender: self)
                        
                    } else {
                        
                        if let errorString = signupError!.userInfo["error"] as? NSString {
                            
                            error = errorString as String
                            
                        } else {
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could Not Log In", error: error)
                        
                        
                    }
                
                signupActive = true
                    
                }
                
            }
            
        } else {
            
            print(self.emailPasswordReset.text!)
            print(PFUser.currentUser()?.email!)
        
          if self.emailPasswordReset.text! != "" {
            
            if (self.emailPasswordReset.text! == PFUser.currentUser()?.email! || PFUser.currentUser()?.email! == nil ) {
        
               PFUser.requestPasswordResetForEmailInBackground(self.emailPasswordReset.text!)
                
                let alert = UIAlertController(title: "Password re-set has been sent", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Email address is incorrect, please try again.", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        
            self.emailPasswordReset.alpha = 0
            self.password.alpha = 1
            self.username.alpha = 1
            self.loginButton.setTitle("Log In", forState: .Normal)
            
          } else {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            
            let alert = UIAlertController(title: "Enter email address!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)

            
            
          }
            
        }
        

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

