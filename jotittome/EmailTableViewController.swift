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

    @IBAction func backButton(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "emailToMessage", sender: self)
        
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
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            if #available(iOS 13.0, *) {
                activityIndicator.style = UIActivityIndicatorView.Style.medium
            } else {
                activityIndicator.style = UIActivityIndicatorView.Style.gray
            }
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            

            
        } else {
            
            print("Internet connection FAILED")
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
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
        return countEmailAddresses
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = ema1[indexPath.row] as String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let ema = ema1[indexPath.row] as String
        
        print(ema)
        
        emailAddressesSelected = ema + "," + emailAddressesSelected
        
        emailActive = 1
        
        self.performSegue(withIdentifier: "emailToMessage", sender: self)
        
        
        
    }
    
}
