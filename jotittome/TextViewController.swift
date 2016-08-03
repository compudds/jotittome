//
//  TextViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/8/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import AddressBookUI
import Parse
import MessageUI


class TextViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact Us", style: .Plain, target: self, action: Selector("contactUs"))*/
        
        self.navigationController?.navigationBarHidden = true
        
        didTouchUpInsidePickButton()
    }
    
    //func didTouchUpInsidePickButton(item: UIBarButtonItem) {
    func didTouchUpInsidePickButton() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [NSNumber(int: kABPersonPhoneProperty)]
        
        if picker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            picker.predicateForEnablingPerson = NSPredicate(format: "phoneNumbers.@count > 0")
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let multiValue: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = ABMultiValueGetIndexForIdentifier(multiValue, identifier)
        let text = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String
        
        let cleanNumber = text
        clean = cleanNumber.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
        
        print(clean)
        
        textActive = 1
        
        print("\(smsNumber)")
        
        self.performSegueWithIdentifier("textToCarrier", sender: self)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person, property: property, identifier: identifier)
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("backToHome", sender: self)
        
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        
                
        //self.performSegueWithIdentifier("backToHome", sender: self)
        
        if(smsNumber > "") {
            
            let alert = UIAlertController(title: "Texts", message: "You selected the following texts: \(smsNumber)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                
                textField.placeholder = "Cell # - no formats."
                textField.keyboardType = UIKeyboardType.NamePhonePad
            
            alert.addAction(UIAlertAction(title: "Manual Texts", style: .Default, handler: { action in
                
            alert.dismissViewControllerAnimated(true, completion: nil)
                
                let cleanNumber = textField.text
                clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                
                if clean == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                       
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.smsNumberNotBlank()
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    textActive = 1

                    self.performSegueWithIdentifier("textToCarrier", sender: self)
                    
                    
                }
                
            }))
             
                
            })
            
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("backToHome", sender: self)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Clear All Texts", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                smsNumber = ""
                mmsNumber = ""
                textActive = 0
                btnColor = ""
                self.performSegueWithIdentifier("backToHome", sender: self)
            }))
            
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Texts", message: "No texts were selected.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
              
                textField.placeholder = "Cell # - no formats."
                textField.keyboardType = UIKeyboardType.NamePhonePad
                
                alert.addAction(UIAlertAction(title: "Manual Texts", style: .Default, handler: { action in
                    
                alert.dismissViewControllerAnimated(true, completion: nil)
                    
                    let cleanNumber = textField.text
                    clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                    
                    if clean == "" {
                        
                        let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                            
                            alert.dismissViewControllerAnimated(true, completion: nil)
                            self.smsNumberBlank()
                            
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        textActive = 1
                    
                       self.performSegueWithIdentifier("textToCarrier", sender: self)
                        
                    }
                    
                    
                }))
                
            })
            
            alert.addAction(UIAlertAction(title: "None", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("backToHome", sender: self)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            

        }
        
    }
    
    func smsNumberNotBlank(){
        
        let alert = UIAlertController(title: "Texts", message: "You selected the following texts: \(smsNumber)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            
            textField.placeholder = "Cell # - no formats."
            textField.keyboardType = UIKeyboardType.NamePhonePad
            
            alert.addAction(UIAlertAction(title: "Manual Texts", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let cleanNumber = textField.text
                clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                
                if clean == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        self.smsNumberNotBlank()
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    textActive = 1
                    
                    self.performSegueWithIdentifier("textToCarrier", sender: self)
                    
                    
                }
                
            }))
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("backToHome", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Clear All Texts", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            smsNumber = ""
            mmsNumber = ""
            textActive = 0
            btnColor = ""
            self.performSegueWithIdentifier("backToHome", sender: self)
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func smsNumberBlank(){
        
        let alert = UIAlertController(title: "Texts", message: "No texts were selected.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            
            textField.placeholder = "Cell # - no formats."
            textField.keyboardType = UIKeyboardType.NamePhonePad
            
            alert.addAction(UIAlertAction(title: "Manual Texts", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let cleanNumber = textField.text
                clean = cleanNumber!.stringByReplacingOccurrencesOfString("[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", withString: "", options: .RegularExpressionSearch)
                
                if clean == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        self.smsNumberBlank()
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    textActive = 1
                
                    self.performSegueWithIdentifier("textToCarrier", sender: self)
                    
                }
                
                
            }))
            
        })
        
        alert.addAction(UIAlertAction(title: "None", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("backToHome", sender: self)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
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
            
            self.performSegueWithIdentifier("backToHome", sender: self)
            
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

    
    
}

