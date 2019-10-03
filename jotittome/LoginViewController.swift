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
    
    func displayAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func create(_ sender: AnyObject) {
        
        
        self.performSegue(withIdentifier: "loginToCreate", sender: self)
        
        
    }
    
    
    @IBOutlet var emailPasswordReset: UITextField!
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        
            self.emailPasswordReset.alpha = 1
            self.loginButton.setTitle("Send", for: UIControl.State())
            self.password.alpha = 0
            self.username.alpha = 0

    }
    
    
    @IBAction func loginn(_ sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if self.emailPasswordReset.alpha == 0 {
        
        if username.text == "" || password.text == "" {
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                error = "Please enter all fields."
                
                displayAlert("Error In Form: ", error: error)
                
            } else {
                
                PFUser.logInWithUsername(inBackground: username.text!, password:password.text!) {
                    (user, signupError) -> Void in
                    
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        print("\(String(describing: PFUser.current()!.username)) is logged in")
                        userEmail = PFUser.current()!.email! + ","
                        userText = PFUser.current()!["mobilePhoneCarrier"]! as! String + ","
                        print(userText)

                        self.performSegue(withIdentifier: "loginToMessage", sender: self)
                        
                    } else {
                        
                        if signupError != nil {
                            
                            error = signupError as! String
                            
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
            print(PFUser.current()?.email! as Any)
        
          if self.emailPasswordReset.text! != "" {
            
            if (self.emailPasswordReset.text! == PFUser.current()?.email! || PFUser.current()?.email! == nil ) {
        
               PFUser.requestPasswordResetForEmail(inBackground: self.emailPasswordReset.text!)
                
                let alert = UIAlertController(title: "Password re-set has been sent", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Email address is incorrect, please try again.", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

        
            self.emailPasswordReset.alpha = 0
            self.password.alpha = 1
            self.username.alpha = 1
            self.loginButton.setTitle("Log In", for: UIControl.State())
            
          } else {
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

            
            let alert = UIAlertController(title: "Enter email address!", message: error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)

            
            
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

