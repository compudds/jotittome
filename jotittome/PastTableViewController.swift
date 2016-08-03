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
    
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("pastToMessage", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        pastReminders = []
        pastRecurrentId = ""
        pastDeleteId = ""
        
        self.refreshControl!.addTarget(self, action: #selector(PastTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    func getPastReminders() {
        
        let currentDate = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let formatCurrentDate = dateFormat.stringFromDate(currentDate)
        //println(formatCurrentDate)
        let query = PFQuery(className:"Reminders")
        query.whereKey("fromemail", equalTo: PFUser.currentUser()!.email!)
        query.whereKey("date1", lessThan: formatCurrentDate)
        query.whereKey("show1", equalTo: true)
        query.orderByDescending("date1")
        query.limit = 500
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
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
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
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
        return pastReminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = "Message: " + pastReminders[indexPath.row] + "\r" + "Delivery: " + pastDate[indexPath.row]
        
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
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            pastId = []
            pastReminders = []
            pastTime = []
            pastDate = []
            
            getPastReminders()
                
            
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //futureEditId = futureId[indexPath.row]
        
        let alert = UIAlertController(title: "Sorry, you can not edit past reminders.", message: "You may delete a past reminder, just left swipe.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.noInternetConnection()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
                pastDeleteId = pastId[indexPath.row]
                print(todayDeleteId)
                let query = PFQuery(className:"Reminders")
                query.whereKey("objectId", equalTo: pastDeleteId)
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
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                       
                        
                        print("PastRecurrentOut: \(pastRecurrentId)")
                        
                        if pastRecurrentId != "no" {
                            
                            let alert = UIAlertController(title: "You are deleting a recurrent reminder!", message: "Do you want to delete all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "All?", style: .Default, handler: { action in
                                
                                alert.dismissViewControllerAnimated(true, completion: nil)
                                
                                let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
                                let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
                                let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                                request.HTTPMethod = "POST"
                                
                                // set Content-Type in HTTP header
                                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                                NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                                
                                
                                // set data
                                let dataString = "message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=yes&show=yes&fromemail=\(parseUser)"
                                
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
                                
                                print("message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=yes&show=yes&fromemail=\(parseUser)")
                                
                                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                
                                
                                self.tableView.reloadData()
                                
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
                                let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                                request.HTTPMethod = "POST"
                                
                                // set Content-Type in HTTP header
                                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                                NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                                
                                
                                // set data
                                let dataString = "message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)"
                                
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
                                
                                print("message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
                                
                                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                
                                
                                self.tableView.reloadData()
                                
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
                            let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 4.0)
                            request.HTTPMethod = "POST"
                            
                            // set Content-Type in HTTP header
                            let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                            let contentType = "multipart/form-data; boundary=" + boundaryConstant
                            NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
                            
                            
                            // set data
                            let dataString = "message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)"
                            
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
                            
                            print("message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&id=\(pastDeleteId)&recurrent=\(pastRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
                            
                            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        }
                        
                        
                    }
                    
                    
                    let alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    pastReminders = []
                    pastRecurrentId = ""
                    pastDeleteId = ""
                    
                    self.getPastReminders()
                    
                    self.tableView.reloadData()
                    
                }
            
            }
        
        
            /*let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update-ios.php")
            let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
            var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
            request.HTTPMethod = "POST"
            
            // set Content-Type in HTTP header
            let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
            let contentType = "multipart/form-data; boundary=" + boundaryConstant
            NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
            
           
            // set data
            var dataString = "message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&show=yes&fromemail=\(parseUser)"
            
            let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = requestBodyData
            
            // set content length
            //NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
            
            var response: NSURLResponse? = nil
            var error: NSError? = nil
            let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
            
            let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
            println("API Response: \(results)")
            
            println("message=\(pastReminders[indexPath.row])&datetime1=\(pastDate[indexPath.row])&show=yes&fromemail=\(parseUser)")
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        }
        
        
        self.tableView.reloadData()
        
        var alert = UIAlertController(title: "Entry Deleted", message: "Your entry has been deleted. It will be deleted from this list the next time you view this table.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            //self.performSegueWithIdentifier("pastToMessages", sender: self)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)*/
       
        //self.performSegueWithIdentifier("pastToMessages", sender: self)
        
        
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        pastReminders = []
        pastRecurrentId = ""
        pastDeleteId = ""
        
        self.getPastReminders()
        
        self.tableView.reloadData()
        
        self.refreshControl!.endRefreshing()
        
    }

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
