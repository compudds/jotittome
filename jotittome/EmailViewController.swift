//
//  EmailViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/8/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import AddressBookUI
import Parse
import MessageUI

var emailAddressesSelected = String()

class EmailViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact Us", style: .Plain, target: self, action: Selector("contactUs"))*/
        self.navigationController?.navigationBarHidden = true
        
        /*if(emailAddressesSelected > ""){
            var alert = UIAlertController(title: "Emails", message: "You selected the following emails: \(emailAddressesSelected)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.didTouchUpInsidePickButton()
            }))
            alert.addAction(UIAlertAction(title: "Re-Set All Emails", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                emailAddressesSelected = ""
                self.didTouchUpInsidePickButton()
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {*/
        
        didTouchUpInsidePickButton()
            
        //}
        
    }
    
    //func didTouchUpInsidePickButton(item: UIBarButtonItem) {
    func didTouchUpInsidePickButton() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        
        if picker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let multiValue: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = ABMultiValueGetIndexForIdentifier(multiValue, identifier)
        let email = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String
        emailAddressesSelected = email + "," + emailAddressesSelected
        print("\(emailAddressesSelected)")
        emailActive = 1
        self.performSegueWithIdentifier("backToHome", sender: self)
        
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person, property: property, identifier: identifier)
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("backToHome", sender: self)
        
        return false;
    }
    
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        
        if(emailAddressesSelected > ""){
            
            let alert = UIAlertController(title: "Emails", message: "You selected the following emails: \(emailAddressesSelected)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Emails, separate by comma."
                
                
                alert.addAction(UIAlertAction(title: "Enter Manual Emails", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    emailActive = 1
                    emailAddressesSelected = "\(textField.text)," + emailAddressesSelected
                    self.performSegueWithIdentifier("backToHome", sender: self)
                }))
            })

            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("backToHome", sender: self)
                
            }))
            alert.addAction(UIAlertAction(title: "Re-Set All Emails", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                emailAddressesSelected = ""
                emailActive = 0
                btnColor = ""
                self.didTouchUpInsidePickButton()
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
            
        } else {
            
            let alert = UIAlertController(title: "Emails", message: "No emails were selected.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Emails, separate by comma."
                
                
                alert.addAction(UIAlertAction(title: "Enter Manual Emails", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                    emailAddressesSelected = "\(textField.text)," + emailAddressesSelected
                    self.performSegueWithIdentifier("backToHome", sender: self)
                }))
                
            })
            
            alert.addAction(UIAlertAction(title: "None", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("backToHome", sender: self)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)

            
        }
  
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
