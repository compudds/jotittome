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
import ContactsUI

var emailAddressesSelected = String()

var ema = String()
var ema1 = [String()]
var countEmailAddresses = Int()
//var emailLabel = [String()]

class EmailViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        if #available(iOS 9.0, *) {
            showContacts()
        
        } else {
            
            didTouchUpInsidePickButton()
        
        }
        
    }
    
    func didTouchUpInsidePickButton() {
        
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [ABPersonEmailAddressesProperty]
        
        if picker.responds(to: #selector(getter: CNContactPickerViewController.predicateForEnablingContact)) {
            picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func showContacts() {
        
        let picker = CNContactPickerViewController()
        
        picker.delegate = self
        
        picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        
        present(picker, animated: true, completion: nil)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        print(contact.emailAddresses.count)
        
        countEmailAddresses = contact.emailAddresses.count
        
        let arrKeys = [CNContactEmailAddressesKey]
        
        if contact.emailAddresses.count > 1 {
            
            for address in contact.emailAddresses {
                
               ema1 = [address.value as String as String] + ema1
           
                ema = address.value as String + "," + ema
            
                picker.displayedPropertyKeys = arrKeys
                
                print("ema1: \(ema1)")
                
                print(address)
                
                emailActive = 1
                
                self.performSegue(withIdentifier: "evcToEtvc", sender: self)
                
            }
            
            
        
        } else {
            
            for address in contact.emailAddresses {
                
                let ema = address.value as String
                
                picker.displayedPropertyKeys = arrKeys
                
                print(ema)
                
                emailAddressesSelected = ema + "," + emailAddressesSelected
                
                emailActive = 1
                
                self.performSegue(withIdentifier: "backToHome", sender: self)
            }
            
            
            
        }
        
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
        
        if(emailAddressesSelected > ""){
            
            let alert = UIAlertController(title: "Emails", message: "You selected the following emails: \(emailAddressesSelected)", preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Emails, separate by comma."
                
                
            alert.addAction(UIAlertAction(title: "Enter Manual Emails", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    emailActive = 1
                    emailAddressesSelected = "\(String(describing: textField.text))," + emailAddressesSelected
                    self.performSegue(withIdentifier: "backToHome", sender: self)
                }))
            })
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "backToHome", sender: self)
                
            }))
            alert.addAction(UIAlertAction(title: "Re-Set All Emails", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                emailAddressesSelected = ""
                emailActive = 0
                btnColor = ""
                //self.didTouchUpInsidePickButton()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            let alert = UIAlertController(title: "Emails", message: "No emails were selected.", preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Emails, separate by comma."
                
                
                alert.addAction(UIAlertAction(title: "Enter Manual Emails", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    emailAddressesSelected = "\(String(describing: textField.text))," + emailAddressesSelected
                    self.performSegue(withIdentifier: "backToHome", sender: self)
                }))
                
            })
            
            alert.addAction(UIAlertAction(title: "None", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "backToHome", sender: self)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        

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
            
            self.performSegue(withIdentifier: "backToHome", sender: self)
            
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

}
