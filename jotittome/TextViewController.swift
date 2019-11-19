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
import ContactsUI

var text = String()

var text1 = [String()]
var textPhoneLabel = [String()]
var cleanNumberLabel = String()
var cleanLabel = [String()]

var countTextNumbers = Int()

class TextViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact Us", style: .Plain, target: self, action: Selector("contactUs"))*/
        
        self.navigationController?.isNavigationBarHidden = true
        
        if #available(iOS 9.0, *) {
            showContacts()
            
        } else {
            
            didTouchUpInsidePickButton()
            
        }

        
        //didTouchUpInsidePickButton()
    }
    
    //@available(iOS 9.0, *)
    func showContacts() {
        
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        controller.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0", argumentArray: nil)
        
        present(controller, animated: true, completion: nil)
    }
    
    //@available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        countTextNumbers = contact.phoneNumbers.count
        
        if contact.phoneNumbers.count > 0 {
            
            for number in contact.phoneNumbers {
                
               
                textPhoneLabel = [number.label!] + textPhoneLabel
                
                print(text1)
                print(number)
                
                print(cleanLabel)
                
                text1 = [(number.value ).value(forKey: "digits") as! String as String] + text1
                
                print("\(smsNumber)")
                
                self.performSegue(withIdentifier: "tvcToTtvc", sender: self)
                
                
            }
            
            
        }
        
    }
    
    //@available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
        
        if(smsNumber > "") {
            
            let alert = UIAlertController(title: "Texts", message: "You selected the following texts: \(smsNumber)", preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                
                textField.placeholder = "Cell # - no formats."
                textField.keyboardType = UIKeyboardType.namePhonePad
                
                alert.addAction(UIAlertAction(title: "Manual Texts", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    let cleanNumber = textField.text
                    clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                    
                    if clean == "" {
                        
                        let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            self.smsNumberNotBlank()
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        textActive = 1
                        
                        self.performSegue(withIdentifier: "textToCarrier", sender: self)
                        
                        
                    }
                    
                }))
                
                
            })
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "backToHome", sender: self)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Clear All Texts", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                smsNumber = ""
                mmsNumber = ""
                textActive = 0
                btnColor = ""
                self.performSegue(withIdentifier: "backToHome", sender: self)
            }))
            
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Texts", message: "No texts were selected.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField(configurationHandler: { (textField) -> Void in
                
                textField.placeholder = "Cell # - no formats."
                textField.keyboardType = UIKeyboardType.namePhonePad
                
                alert.addAction(UIAlertAction(title: "Manual Texts", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    let cleanNumber = textField.text
                    clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                    
                    if clean == "" {
                        
                        let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            self.smsNumberBlank()
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        textActive = 1
                        
                        self.performSegue(withIdentifier: "textToCarrier", sender: self)
                        
                    }
                    
                    
                }))
                
            })
            
            alert.addAction(UIAlertAction(title: "None", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "backToHome", sender: self)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    func didTouchUpInsidePickButton() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [ABPersonPhoneNumbersProperty]
        
        if picker.responds(to: #selector(getter: CNContactPickerViewController.predicateForEnablingContact)) {
            picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func smsNumberNotBlank(){
        
        let alert = UIAlertController(title: "Texts", message: "You selected the following texts: \(smsNumber)", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            
            textField.placeholder = "Cell # - no formats."
            textField.keyboardType = UIKeyboardType.namePhonePad
            
            alert.addAction(UIAlertAction(title: "Manual Texts", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                let cleanNumber = textField.text
                clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                
                if clean == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        self.smsNumberNotBlank()
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    textActive = 1
                    
                    self.performSegue(withIdentifier: "textToCarrier", sender: self)
                    
                    
                }
                
            }))
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "backToHome", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Clear All Texts", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            smsNumber = ""
            mmsNumber = ""
            textActive = 0
            btnColor = ""
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func smsNumberBlank(){
        
        let alert = UIAlertController(title: "Texts", message: "No texts were selected.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            
            textField.placeholder = "Cell # - no formats."
            textField.keyboardType = UIKeyboardType.namePhonePad
            
            alert.addAction(UIAlertAction(title: "Manual Texts", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                let cleanNumber = textField.text
                clean = cleanNumber!.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
                
                if clean == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter a text number.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        self.smsNumberBlank()
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    textActive = 1
                
                    self.performSegue(withIdentifier: "textToCarrier", sender: self)
                    
                }
                
                
            }))
            
        })
        
        alert.addAction(UIAlertAction(title: "None", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    
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

    
    


