//
//  FutureTableViewController.swift
//  jotittome
//
//  Created by Eric Cook on 5/20/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var futureEditEmail = String()
var futureEditText = String()
var futureEditId = String()
var futureDeleteId = String()
var futureId = [String]()
var futureRecurrentId = String()
var futureEditReminders = String()
var futureEditDate = String()
var futureEditTime = String()
var futureEditSent = String()
var futureEditSent1 = Bool()

class FutureTableViewController: UITableViewController {
    
    
    @IBAction func backToHome(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "futureToMessages", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        print("id=\(futureEditId) message=\(futureEditReminders) date=\(futureEditDate) time=\(futureEditTime) email=\(futureEditEmail) text=\(futureEditText) sent=\(futureEditSent) show=yes fromemail=\(parseUser)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        futureReminders = []
        futureRecurrentId = ""
        futureDeleteId = ""
        
        self.refreshControl!.addTarget(self, action: #selector(FutureTableViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return futureReminders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = "Message: " + futureReminders[indexPath.row] + "\r" + "Delivery: " + futureDate[indexPath.row] + " " + futureTime[indexPath.row]

        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            
            futureDeleteId = futureId[indexPath.row]
            print(futureDeleteId)
            let query = PFQuery(className:"Reminders")
            query.whereKey("objectId", equalTo: futureDeleteId)
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
                                futureRecurrentId = object["recurrent"] as! String
                                
                            } else {
                                
                                let recurrent = object["recurrent"] as! String
                                
                                if recurrent.isEmpty {
                                    object["recurrent"] = "no"
                                    object.saveEventually()
                                    futureRecurrentId = "no"
                                    
                                } else {
                                    
                                    futureRecurrentId = object["recurrent"] as! String
                                }
                                
                                print("FutureRecurrentIn: \(futureRecurrentId)")
                                
                            }
                            
                            
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) ")
                }
                
                self.tableView.reloadData()
                
            })
            print(futureRecurrentId)
            
            if (futureRecurrentId != "no") {
                
                let alert = UIAlertController(title: "You are deleting a recurrent reminder!", message: "Do you want to delete all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "All?", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                    let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                    let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 10.0)
                    request.httpMethod = "POST"
                    
                    // set Content-Type in HTTP header
                    let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                    let contentType = "multipart/form-data; boundary=" + boundaryConstant
                    URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                    
                    
                    // set data
                    let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)"
                    
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
                    
                    print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)")
                    
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
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
                    let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)"
                    
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
                    print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)")
                    
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
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
            let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)"
            
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
            print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)")
            
                let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    //self.performSegueWithIdentifier("pastToMessages", sender: self)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                futureReminders = []
                futureRecurrentId = ""
                futureDeleteId = ""

                getFutureReminders()
                
                self.tableView.reloadData()
            
        }
        
        
       }
    
    
    }
    
    @objc func refresh(_ sender:AnyObject) {
        
        // Updating your data here...
        //self.refreshControl!.endRefreshing()
        
        futureEditId = ""
        futureEditReminders = ""
        futureEditDate = ""
        futureEditTime = ""
        futureEditEmail = ""
        futureEditText = ""
        futureEditSent = ""
        futureRecurrentId = ""
        futureDeleteId = ""
        
        getFutureReminders()
        
        self.tableView.reloadData()
        
        self.refreshControl!.endRefreshing()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        futureEditId = futureId[indexPath.row]
    
        let query = PFQuery(className:"Reminders")
        query.whereKey("objectId", equalTo: futureEditId)
        print("futureId: \(futureId[indexPath.row])")
        query.findObjectsInBackground (block: {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) future reminders.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        futureEditReminders = object["message"] as! String
                        futureEditDate = object["date1"] as! String
                        futureEditTime = object["time1"] as! String
                        futureEditEmail = object["email"] as! String
                        futureEditText = object["text"] as! String
                        futureEditSent1 = object["sent"] as! Bool
                        futureRecurrentId = object["recurrent"] as! String
                        
                        if (futureEditSent1 == true) {
                            
                            futureEditSent = "true"
                            
                        } else {
                            
                            futureEditSent = "false"
                            
                        }
                        
                    }
                    
                }
                
                print("id=\(futureEditId) message=\(futureEditReminders) date=\(futureEditDate) time=\(futureEditTime) email=\(futureEditEmail) text=\(futureEditText) sent=\(futureEditSent) show=yes fromemail=\(parseUser)")
                
               
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
            
            //self.tableView.reloadData()
        })
        
       self.performSegue(withIdentifier: "futureToEditFuture", sender: self)
    
    }
    
    func getFutureReminders() {
        
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let formatCurrentDate = dateFormat.string(from: currentDate)
        //println(formatCurrentDate)
        let query = PFQuery(className:"Reminders")
        query.whereKey("fromemail", equalTo: PFUser.current()!.email!)
        query.whereKey("date1", greaterThan: formatCurrentDate)
        query.whereKey("show1", equalTo: true)
        query.order(byAscending: "date1")
        query.limit = 500
        query.findObjectsInBackground (block: {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) future reminders.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let objectId = object.objectId
                        futureId = futureId + [objectId!]
                        //println(futureId)
                        futureReminders.append(object["message"] as! String)
                        futureDate.append(object["date1"] as! String)
                        futureTime.append(object["time1"] as! String)
                        
                        /*if object["recurrent"] == nil {
                            object["recurrent"] = "no"
                            object.save()
                            futureRecurrentId = object["recurrent"] as! String
                        } else {
                            futureRecurrentId = object["recurrent"] as! String
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
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            futureId = []
            futureReminders = []
            futureTime = []
            futureDate = []
            
            getFutureReminders()
            
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
