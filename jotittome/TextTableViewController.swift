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
    
    @IBAction func backButton(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "textToMessage", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       noInternetConnection()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            count = 0
            textArray = []
            textContactName = []
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //test()
            
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return countTextNumbers
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
        if textPhoneLabel[indexPath.row] == "_$!<Work>!$_" {
            
            textPhoneLabel[indexPath.row] = "Work"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<Home>!$_" {
            
            textPhoneLabel[indexPath.row] = "Home"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<Mobile>!$_" {
            
            textPhoneLabel[indexPath.row] = "Mobile"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<iPhone>!$_" {
            
            textPhoneLabel[indexPath.row] = "iPhone"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<HomeFAX>!$_" {
            
            textPhoneLabel[indexPath.row] = "Home Fax"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<WorkFAX>!$_" {
            
            textPhoneLabel[indexPath.row] = "Work Fax"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<Main>!$_" {
            
            textPhoneLabel[indexPath.row] = "Main"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<Other>!$_" {
            
            textPhoneLabel[indexPath.row] = "Other"
        }
        
        if textPhoneLabel[indexPath.row] == "_$!<Pager>!$_" {
            
            textPhoneLabel[indexPath.row] = "Pager"
        }
        
        
        
        cell.textLabel?.text = textPhoneLabel[indexPath.row] + ": " + text1[indexPath.row] as String
        
        //cell.textLabel?.text = "Phone"//text1[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let textNumberPicked = text1[indexPath.row] as String
        
        print(textNumberPicked)
        
        text1 = [textNumberPicked] //+ "," + text1
        
        let cleanNumber = "\(textNumberPicked)"
        
        clean = cleanNumber.replacingOccurrences(of: "[a-zA-Z\\-\\*\\#\\@\\+\\(\\)\\.\" \"]", with: "", options: .regularExpression)
        
        print(clean)

        
        textActive = 1
        
        self.performSegue(withIdentifier: "ttvcToCarrier", sender: self)
        
        
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
