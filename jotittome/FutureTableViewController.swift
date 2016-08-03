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
    
    
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("futureToMessages", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        print("id=\(futureEditId) message=\(futureEditReminders) date=\(futureEditDate) time=\(futureEditTime) email=\(futureEditEmail) text=\(futureEditText) sent=\(futureEditSent) show=yes fromemail=\(parseUser)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        futureReminders = []
        futureRecurrentId = ""
        futureDeleteId = ""
        
        self.refreshControl!.addTarget(self, action: #selector(FutureTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        noInternetConnection()
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
        return futureReminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = "Message: " + futureReminders[indexPath.row] + "\r" + "Delivery: " + futureDate[indexPath.row] + " " + futureTime[indexPath.row]

        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            futureDeleteId = futureId[indexPath.row]
            print(futureDeleteId)
            let query = PFQuery(className:"Reminders")
            query.whereKey("objectId", equalTo: futureDeleteId)
            query.limit = 500
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
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
                    print("Error: \(error!) \(error!.userInfo)")
                }
                
                self.tableView.reloadData()
                
            }
            print(futureRecurrentId)
            
            if (futureRecurrentId != "no") {
                
                let alert = UIAlertController(title: "You are deleting a recurrent reminder!", message: "Do you want to delete all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "All?", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                    let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
                    let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 10.0)
                    request.HTTPMethod = "POST"
                    
                    // set Content-Type in HTTP header
                    let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                    let contentType = "multipart/form-data; boundary=" + boundaryConstant
                    NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                    
                    
                    // set data
                    let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)"
                    
                    let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    request.HTTPBody = requestBodyData
                    
                    // set content length
                    //NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
                    
                    var response: NSURLResponse? = nil
                    //var error: NSError? = nil
                    let reply: NSData?
                    do {
                        reply = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                    } catch let error1 as NSError {
                        print(error1)
                        reply = nil
                    } catch {
                        fatalError()
                    }
                    
                    let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
                    print("API Response: \(results)")
                    
                    print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=yes&show=no&sent=yes&fromemail=\(parseUser)")
                    
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted. It will be deleted from this list the next time you view this table.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        //self.performSegueWithIdentifier("pastToMessages", sender: self)
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    

                    
                }))
                
                alert.addAction(UIAlertAction(title: "This one?", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                    let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
                    let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
                    request.HTTPMethod = "POST"
                    
                    // set Content-Type in HTTP header
                    let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                    let contentType = "multipart/form-data; boundary=" + boundaryConstant
                    NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                    
                    
                    // set data
                    let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)"
                    
                    let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    request.HTTPBody = requestBodyData
                    
                    // set content length
                    //NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
                    
                    var response: NSURLResponse? = nil
                    //var error: NSError? = nil
                    let reply: NSData?
                    do {
                        reply = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                    } catch let error1 as NSError {
                        print(error1)
                        reply = nil
                    } catch {
                        fatalError()
                    }
                    
                    let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
                    print("API Response: \(results)")
                    
                    print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)")
                    
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted. It will be deleted from this list the next time you view this table.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        //self.performSegueWithIdentifier("pastToMessages", sender: self)
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    

                    
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
            } else {
                
            
            let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
            let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
            let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
            request.HTTPMethod = "POST"
            
            // set Content-Type in HTTP header
            let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
            let contentType = "multipart/form-data; boundary=" + boundaryConstant
            NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
            
            
            // set data
            let dataString = "message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)"
            
            let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = requestBodyData
            
            // set content length
            //NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
            
            var response: NSURLResponse? = nil
            //var error: NSError? = nil
            let reply: NSData?
            do {
                reply = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error1 as NSError {
                print(error1)
                reply = nil
            }
            
            let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
            print("API Response: \(results)")
            
            print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=no&sent=yes&fromemail=\(parseUser)")
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    //self.performSegueWithIdentifier("pastToMessages", sender: self)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                futureReminders = []
                futureRecurrentId = ""
                futureDeleteId = ""

                getFutureReminders()
                
                self.tableView.reloadData()
            
        }
        
        
       }
    
    
    }
    
    func refresh(sender:AnyObject) {
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        futureEditId = futureId[indexPath.row]
    
        let query = PFQuery(className:"Reminders")
        query.whereKey("objectId", equalTo: futureEditId)
        print("futureId: \(futureId[indexPath.row])")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
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
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            //self.tableView.reloadData()
        }
        
       self.performSegueWithIdentifier("futureToEditFuture", sender: self)
    
    }
    
    func getFutureReminders() {
        
        let currentDate = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let formatCurrentDate = dateFormat.stringFromDate(currentDate)
        //println(formatCurrentDate)
        let query = PFQuery(className:"Reminders")
        query.whereKey("fromemail", equalTo: PFUser.currentUser()!.email!)
        query.whereKey("date1", greaterThan: formatCurrentDate)
        query.whereKey("show1", equalTo: true)
        query.orderByAscending("date1")
        query.limit = 500
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
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
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
        }
        
    }
      
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            futureId = []
            futureReminders = []
            futureTime = []
            futureDate = []
            
            getFutureReminders()
            
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
