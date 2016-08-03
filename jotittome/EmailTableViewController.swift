//
//  EmailTableViewController.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import AddressBook
//import MessageUI

var emails = [String]()
var count = 0
var users = [""]
var following = [Bool]()
var contactName1 = [String]()
var emailArray = [String]()
var emailID1 = String()
var favEmails = [String]()
var favEmails1 = [String]()




class EmailTableViewController: UITableViewController {

    @IBAction func backButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("emailToMessage", sender: self)
        
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
                    
                    if emailArray == [] || contactName1 == []{
                        
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
            
            if record as? NSObject == nil {
                
                print("Error in field! \(record)")
                
            } else {
                
                let contactPerson: ABRecordRef = record
                
                let contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
                
                var firstName = ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty).takeUnretainedValue() as! String
                
                var lastName = ABRecordCopyValue(contactPerson, kABPersonLastNameProperty).takeUnretainedValue() as! String
        
                if firstName == "" || lastName == "" {
                    
                    firstName = "Eric"
                    lastName = "Cook"
                    
                }


                
                let emailProperty: ABMultiValueRef = ABRecordCopyValue(contactPerson, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
                
                if ABMultiValueGetCount(emailProperty) > 0 {
                    
                    let allEmailIDs: NSArray = ABMultiValueCopyArrayOfAllValues(emailProperty).takeUnretainedValue() as NSArray
                    
                    for email in allEmailIDs {
                        
                        count += 1
                        
                        let emailID = email as! String
                        
                        if (emailID != "") {
                            
                            emailID1 = "\(emailID), " + emailID1
                            emailArray = [emailID] + emailArray
                            contactName1 = [contactName] + contactName1
                            print ("\(count). Name: \(contactName1) Email: \(emailID) \n")
                            print("Array: \(emailArray) \n")
                        
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
            
            count = 0
            //emailArray = []
            //contactName1 = []
            following = []
            
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
        return emailArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
     
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = contactName1[indexPath.row] as String + " \n " + emailArray[indexPath.row] as String
        
        if following.count > indexPath.row {
            
            if following[indexPath.row] == true {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                favEmails = [contactName1[indexPath.row] as String + " " + emailArray[indexPath.row] as String] + favEmails
                favEmails1 = [emailArray[indexPath.row] as String] + favEmails1
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
            
           /* var query = PFQuery(className:"followers")
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
            favEmails = [contactName1[indexPath.row] as String + " " + emailArray[indexPath.row] as String] + favEmails
            favEmails1 = [emailArray[indexPath.row] as String] + favEmails1
            /*var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.save()
            
            println("\(PFUser.currentUser().username) is following \(cell.textLabel?.text)")*/
            
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
