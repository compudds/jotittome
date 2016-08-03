//
//  TextTableViewController.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import AddressBook

var textArray = [String]()
var textContactName = [String]()
var sortTextName: Unmanaged<CFArray>?
var favTexts = [String]()

class TextTableViewController: UITableViewController {
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("textToMessage", sender: self)
        
    }
    
    var addressBook: ABAddressBookRef?
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    
    func test() {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            print("Requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    
                    if textArray == [] || textContactName == [] {
                        
                        self.getContactNames()
                    }
                    
                } else {
                    print("Error: \(error)")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            print("Access denied.")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            print("Access granted.")
            self.getContactNames()
            
        }
        
    }
    
    func getContactNames() {
        
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        
        
        print("Records in the array - \(contactList.count)")
        
        for record:ABRecordRef in contactList {
            
            if record as! NSObject == [] {
                
                print("Error in field! \(record)")
                
            } else {
              
                
                let contactPerson: ABRecordRef = record
                let contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
                _ = ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty).takeUnretainedValue() as! String
                _ = ABRecordCopyValue(contactPerson, kABPersonLastNameProperty).takeUnretainedValue() as! String
                //var textNumber = ABRecordCopyValue(contactPerson, kABPersonPhoneMobileLabel).takeUnretainedValue() as! String
                let textProperty: ABMultiValueRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
                //var emailProperty: ABMultiValueRef = ABRecordCopyValue(contactPerson, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
                
                if ABMultiValueGetCount(textProperty) > 0 {
                    
                    let allTextIDs: NSArray = ABMultiValueCopyArrayOfAllValues(textProperty).takeUnretainedValue() as NSArray
                    
                    /*
                    for(var numberIndex : CFIndex = 0; numberIndex < ABMultiValueGetCount(textProperty); numberIndex++)
                    {
                        
                        // Number in contact details of current index
                        
                        let phoneUnmaganed = ABMultiValueCopyValueAtIndex(textProperty, numberIndex)
                        
                        
                        let phoneNumber : NSString = phoneUnmaganed.takeUnretainedValue() as! NSString
                        
                        // Label of Phone Number
                        
                        let locLabel : CFStringRef = (ABMultiValueCopyLabelAtIndex(textProperty, numberIndex) != nil) ? ABMultiValueCopyLabelAtIndex(textProperty, numberIndex).takeUnretainedValue() as CFStringRef : ""
                        
                        //check for home
                        if (String(locLabel) == String(kABHomeLabel))
                        {
                            contact.sUserTelHome =  phoneNumber as String
                            contact.sUserTelHomeTrim = contact.sUserTelHome?.trimmedContactNumber()
                            
                        }
                            
                            //check for work
                        else if (String(locLabel) == String(kABWorkLabel))
                        {
                            contact.sUserTelWork = phoneNumber as String
                            contact.sUserTelWorkTrim = contact.sUserTelWork?.trimmedContactNumber()
                            
                        }
                            
                            //check for mobile
                        else if (String(locLabel) == String(kABPersonPhoneMobileLabel))
                        {
                            contact.sUserTelMobile = phoneNumber as String
                            contact.sUserTelMobileTrim = contact.sUserTelMobile?.trimmedContactNumber()
                        }
                            
                        else if(String(locLabel) == String(kABOtherLabel)){
                            
                            
                            
                        }
                    }*/
                    
                    var i = 0
                    
                    for text in allTextIDs {
                        
                        count += 1
                        let textID = text as! String
                        
                        if (textID != "") {
                        //emailID1 = "\(textID), " + emailID1
                        textArray = [textID] + textArray
                        textContactName = [contactName] + textContactName
                        //sortTextName = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, textContactName, 1)
                        print ("\(count). Name: \(textContactName) Text: \(textID) \n")
                        print("Array: \(textArray) \n  \(sortTextName)")
                        i += 1
                        
                        }
                        
                    }
                    
                }
               
            }
                
        }
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       noInternetConnection()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print("Internet connection OK")
            
            count = 0
            textArray = []
            textContactName = []
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            test()
            
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return textArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = textContactName[indexPath.row] as String + "\n" + textArray[indexPath.row] as String
        
        if following.count > indexPath.row {
            
            if following[indexPath.row] == true {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                favTexts = [textContactName[indexPath.row] as String + " " + textArray[indexPath.row] as String] + favTexts
                
            }
            
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //iPathEmail = [emails[indexPath.row]]
        
        //iPathText = [texts[indexPath.row]]
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            /*var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo:cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
            
            for object in objects {
            
            object.deleteEventually()   //deleteInBackground()
            
            }
            println("\(PFUser.currentUser().username) unfollowing \(cell.textLabel?.text)")
            } else {
            // Log details of the failure
            println(error)
            }
            }*/
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            favTexts = [textContactName[indexPath.row] as String + " " + textArray[indexPath.row] as String] + favTexts
            /*var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.save()
            
            println("\(PFUser.currentUser().username) is following \(cell.textLabel?.text)")*/
            
        }
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
