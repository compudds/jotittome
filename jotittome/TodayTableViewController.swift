//
//  TodayTableViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/20/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var todayEditEmail = String()
var todayEditText = String()
var todayEditId = String()
var todayDeleteId = String()
var todayId = [String]()
var todayRecurrentId = String()
var todayEditReminders = String()
var todayEditDate = String()
var todayEditTime = String()
var todayEditSent = String()
var todayEditSent1 = Bool()

class TodayTableViewController: UITableViewController {
    
    
    @IBAction func backToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "todayToMessages", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        print("id=\(todayEditId) message=\(todayEditReminders) date=\(todayEditDate) time=\(todayEditTime) email=\(todayEditEmail) text=\(todayEditText) sent=\(todayEditSent) show=yes fromemail=\(parseUser)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        todayReminders = []
        todayRecurrentId = ""
        todayDeleteId = ""
        
        self.refreshControl!.addTarget(self, action: #selector(TodayTableViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        
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
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        return todayReminders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = "Message: " + todayReminders[indexPath.row] + "\r" + "Delivery: " + todayDate[indexPath.row] + " " + todayTime[indexPath.row]
        
        return cell
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            todayDeleteId = todayId[(indexPath as NSIndexPath).row]
            print(todayDeleteId)
            let query = PFQuery(className:"Reminders")
            query.whereKey("objectId", equalTo: todayDeleteId)
            query.limit = 500
            query.findObjectsInBackground ( block: {
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
                                todayRecurrentId = object["recurrent"] as! String
                                
                            } else {
                                
                            let recurrent = object["recurrent"] as! String
                                
                                if recurrent.isEmpty {
                                    object["recurrent"] = "no"
                                    object.saveEventually()
                                    todayRecurrentId = "no"
                                
                                } else {
                                
                                    todayRecurrentId = object["recurrent"] as! String
                                }
                            
                            print("TodayRecurrentIn: \(todayRecurrentId)")
                                
                            }
                            
                            
                        }
                        
                   // }
                    
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) ")
                }
                
                print("TodayRecurrentOut: \(todayRecurrentId)")
                
                if todayRecurrentId != "no" {
                    
                    let alert = UIAlertController(title: "You are deleting a recurrent reminder!", message: "Do you want to delete all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "All?", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                        let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                        let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
                        request.httpMethod = "POST"
                        
                        // set Content-Type in HTTP header
                        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                        let contentType = "multipart/form-data; boundary=" + boundaryConstant
                        URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                        
                        
                        // set data
                        let dataString = "message=\(todayReminders[indexPath.row])&datetime1=\(todayDate[indexPath.row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)"
                        
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
                        
                        print("message=\(todayReminders[(indexPath as NSIndexPath).row])&datetime1=\(todayDate[(indexPath as NSIndexPath).row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)")
                        
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
                        let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
                        request.httpMethod = "POST"
                        
                        // set Content-Type in HTTP header
                        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                        let contentType = "multipart/form-data; boundary=" + boundaryConstant
                        URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                        
                        
                        // set data
                        let dataString = "message=\(todayReminders[(indexPath as NSIndexPath).row])&datetime1=\(todayDate[(indexPath as NSIndexPath).row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)"
                        
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
                        print("message=\(todayReminders[(indexPath as NSIndexPath).row])&datetime1=\(todayDate[(indexPath as NSIndexPath).row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)")
                        
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
                    let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
                    request.httpMethod = "POST"
                    
                    // set Content-Type in HTTP header
                    let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                    let contentType = "multipart/form-data; boundary=" + boundaryConstant
                    URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                    
                    
                    // set data
                    let dataString = "message=\(todayReminders[(indexPath as NSIndexPath).row])&datetime1=\(todayDate[(indexPath as NSIndexPath).row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=no&show=no&sent=&fromemail=\(parseUser)"
                    
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
                    
                    print("message=\(todayReminders[(indexPath as NSIndexPath).row])&datetime1=\(todayDate[(indexPath as NSIndexPath).row])&id=\(todayDeleteId)&recurrent=\(todayRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
                    
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                }

                
            }
            
            
            let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                //self.performSegueWithIdentifier("pastToMessages", sender: self)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            todayReminders = []
            todayRecurrentId = ""
            todayDeleteId = ""
    
            self.getTodayReminders()
            
            self.tableView.reloadData()
            
        })
        
        }
        
        //self.performSegueWithIdentifier("todayToMessages", sender: self)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        todayEditId = todayId[indexPath.row]
        
        let query = PFQuery(className:"Reminders")
        query.whereKey("objectId", equalTo: todayEditId)
        query.findObjectsInBackground (block: {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) future reminders.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        //todayEditId = todayId[indexPath.row]
                        todayEditReminders = object["message"] as! String
                        todayEditDate = object["date1"] as! String
                        todayEditTime = object["time1"] as! String
                        todayEditEmail = object["email"] as! String
                        todayEditText = object["text"] as! String
                        todayEditSent1 = object["sent"] as! Bool
                        
                        if (todayEditSent1 == true) {
                            
                            todayEditSent = "true"
                        
                        } else {
                            
                            todayEditSent = "false"
                        
                        }
                        
                    }
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
        })
    
        self.performSegue(withIdentifier: "todayToEditToday", sender: self)
    
    }
    
    func getTodayReminders() {
        
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let formatCurrentDate = dateFormat.string(from: currentDate)
        //println(formatCurrentDate)
        let query = PFQuery(className:"Reminders")
        query.whereKey("fromemail", equalTo: PFUser.current()!.email!)
        query.whereKey("date1", equalTo: formatCurrentDate)
        query.whereKey("show1", equalTo: true)
        query.order(byDescending: "time1")
        query.limit = 500
        query.findObjectsInBackground (block: {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) today reminders.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let objectId = object.objectId
                        todayId = todayId + [objectId!]
                        todayReminders.append(object["message"] as! String)
                        todayDate.append(object["date1"] as! String)
                        todayTime.append(object["time1"] as! String)
                        
                        /*if (object["recurrent"] == nil) {
                            object["recurrent"] = "no"
                            object.save()
                            todayRecurrentId.append(object["recurrent"] as! String)
                        } else {
                            todayRecurrentId.append(object["recurrent"] as! String)
                        }*/
                        
                    }
                
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
            self.tableView.reloadData()
        })
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            todayId = []
            todayReminders = []
            todayTime = []
            todayDate = []
            
            getTodayReminders()
                
            
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
    
    @objc func refresh(_ sender:AnyObject){
        
        // Updating your data here...
        //self.refreshControl!.endRefreshing()
        
        todayEditId = ""
        todayEditDate = ""
        todayEditTime = ""
        todayEditEmail = ""
        todayEditText = ""
        todayEditSent = ""
        todayRecurrentId = ""
        todayDeleteId = ""
        
        getTodayReminders()
        
        self.tableView.reloadData()
        
        self.refreshControl!.endRefreshing()
        
    }
    
}
