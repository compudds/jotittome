//
//  PastTableViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/20/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var pastDeleteId = String()
var pastId = [String]()
var pastRecurrentId = String()

class PastTableViewController: UITableViewController {
    
    //var refreshControl:UIRefreshControl?
    
    @IBAction func backToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "pastToMessage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pastReminders = []
        pastRecurrentId = ""
        pastDeleteId = ""
        
        self.refreshControl!.addTarget(self, action: #selector(PastTableViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        self.navigationController?.isNavigationBarHidden = true
        
        noInternetConnection()
    }
    
    func getPastReminders() {
        
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let formatCurrentDate = dateFormat.string(from: currentDate)
        //println(formatCurrentDate)
        let query = PFQuery(className:"Reminders")
        query.whereKey("fromemail", equalTo: PFUser.current()!.email!)
        query.whereKey("date1", lessThan: formatCurrentDate)
        query.whereKey("show1", equalTo: true)
        query.order(byDescending: "date1")
        query.limit = 500
        query.findObjectsInBackground (block: {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) past reminders.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let objectId = object.objectId
                        pastId = pastId + [objectId!]
                        pastReminders.append(object["message"] as! String)
                        pastDate.append(object["datetime1"] as! String)
                        pastTime.append(object["time1"] as! String)
                        
                    }
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
            
            self.tableView.reloadData()
        })
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        return pastReminders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = "Message: " + pastReminders[(indexPath as NSIndexPath).row] + "\r" + "Delivery: " + pastDate[(indexPath as NSIndexPath).row]
        
        //activityIndicator.stopAnimating()
        //self.view.isUserInteractionEnabled = true
        
        return cell
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.performSegueWithIdentifier("pastToOld", sender: self)
        
    }*/
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            pastId = []
            pastReminders = []
            pastTime = []
            pastDate = []
            
            getPastReminders()
                
            
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
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //futureEditId = futureId[indexPath.row]
        
        let alert = UIAlertController(title: "Sorry, you can not edit past reminders.", message: "You may delete a past reminder, just left swipe.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.noInternetConnection()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            
                pastDeleteId = pastId[(indexPath as NSIndexPath).row]
                print(todayDeleteId)
                let query = PFQuery(className:"Reminders")
                query.whereKey("objectId", equalTo: pastDeleteId)
                query.limit = 500
            query.findObjectsInBackground (block: {
                    (objects, error) in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) today reminders.")
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                
                                if object["recurrent"] == nil {
                                    object["recurrent"] = "no"
                                    object.saveEventually()
                                    pastRecurrentId = object["recurrent"] as! String
                                    
                                } else {
                                    
                                    let recurrent = object["recurrent"] as! String
                                    
                                    if recurrent.isEmpty {
                                        object["recurrent"] = "no"
                                        object.saveEventually()
                                        pastRecurrentId = "no"
                                        
                                    } else {
                                        
                                        pastRecurrentId = object["recurrent"] as! String
                                    }
                                    
                                    print("PastRecurrentIn: \(pastRecurrentId)")
                                    
                                }
                                
                                
                            }
                            
                           
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) ")
                        }
                       
                        
                        print("PastRecurrentOut: \(pastRecurrentId)")
                        
                        if pastRecurrentId != "no" {
                            
                            let alert = UIAlertController(title: "You are deleting a recurrent reminder!", message: "Do you want to delete all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "All?", style: .default, handler: { action in
                                
                                alert.dismiss(animated: true, completion: nil)
                                
                                let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                                let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                                let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                                request.httpMethod = "POST"
                                
                                // set Content-Type in HTTP header
                                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                                URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                                
                                
                                // set data
                                let dataString = "message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=yes&show=yes&fromemail=\(parseUser)"
                                
                                let requestBodyData = (dataString as NSString).data(using: String.Encoding.utf8.rawValue)
                                request.httpBody = requestBodyData
                                
                                let session = URLSession.shared
                                
                                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                                    
                                    if error == nil {
                                        
                                        print("Data: \(data!)")
                                        
                                        print("Response: \(response!)")
                                        
                                        let results = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)
                                        
                                        print("API Response: \(String(describing: results!))")
                                        
                                        
                                    } else {
                                        
                                        print("Error: \(error!)")
                                        
                                    }
                                    
                                })
                                
                                
                                task.resume()
                                
                                print("message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=yes&show=yes&fromemail=\(parseUser)")
                                
                                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                
                                
                                self.tableView.reloadData()
                                
                                let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted. It will be deleted from this list the next time you view this table.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                    
                                    alert.dismiss(animated: true, completion: nil)
                                    //self.performSegueWithIdentifier("pastToMessages", sender: self)
                                    
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                                
                            }))
                            alert.addAction(UIAlertAction(title: "This one?", style: .default, handler: { action in
                                
                                alert.dismiss(animated: true, completion: nil)
                                let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                                let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                                let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                                request.httpMethod = "POST"
                                
                                // set Content-Type in HTTP header
                                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                                URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                                
                                
                                // set data
                                let dataString = "message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)"
                                
                                let requestBodyData = (dataString as NSString).data(using: String.Encoding.utf8.rawValue)
                                request.httpBody = requestBodyData
                                
                                let session = URLSession.shared
                                
                                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                                    
                                    if error == nil {
                                        
                                        print("Data: \(data!)")
                                        
                                        print("Response: \(response!)")
                                        
                                        let results = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)
                                        
                                        print("API Response: \(String(describing: results!))")
                                        
                                        
                                    } else {
                                        
                                        print("Error: \(error!)")
                                        
                                    }
                                    
                                })
                                
                                
                                task.resume()
                                print("message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
                                
                                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                
                                
                                self.tableView.reloadData()
                                
                                let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted. It will be deleted from this list the next time you view this table.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                    
                                    alert.dismiss(animated: true, completion: nil)
                                    //self.performSegueWithIdentifier("pastToMessages", sender: self)
                                    
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                                
                                alert.dismiss(animated: true, completion: nil)
                                
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else {
                            
                            let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                            let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                            let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                            request.httpMethod = "POST"
                            
                            // set Content-Type in HTTP header
                            let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                            let contentType = "multipart/form-data; boundary=" + boundaryConstant
                            URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                            
                            
                            // set data
                            let dataString = "message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)"
                            
                            let requestBodyData = (dataString as NSString).data(using: String.Encoding.utf8.rawValue)
                            request.httpBody = requestBodyData
                            
                            let session = URLSession.shared
                            
                            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                                
                                if error == nil {
                                    
                                    print("Data: \(data!)")
                                    
                                    print("Response: \(response!)")
                                    
                                    let results = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)
                                    
                                    print("API Response: \(String(describing: results!))")
                                    
                                    
                                } else {
                                    
                                    print("Error: \(error!)")
                                    
                                }
                                
                            })
                            
                            
                            task.resume()
                            
                            print("message=\(pastReminders[(indexPath as NSIndexPath).row])&datetime1=\(pastDate[(indexPath as NSIndexPath).row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
                            
                            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        }
                        
                        
                    }
                    
                    
                    let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    pastReminders = []
                    pastRecurrentId = ""
                    pastDeleteId = ""
                    
                    self.getPastReminders()
                    
                    self.tableView.reloadData()
                    
                })
            
            }
        
    }
    
    @objc func refresh(_ sender:AnyObject)
    {
        // Updating your data here...
        
        pastReminders = []
        pastRecurrentId = ""
        pastDeleteId = ""
        
        self.getPastReminders()
        
        self.tableView.reloadData()
        
        self.refreshControl!.endRefreshing()
        
    }


}
