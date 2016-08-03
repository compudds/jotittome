//
//  EditTodayViewController.swift
//  jotittome
//
//  Created by Eric Cook on 6/28/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit

class EditTodayViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func cancel(sender: AnyObject) {
        
        self.performSegueWithIdentifier("editTodayToToday", sender: self)
    }
    
    @IBOutlet var scroll: UIScrollView!
    
    @IBOutlet var date: UITextField!
    
    @IBOutlet var time: UITextField!
    
    @IBOutlet var message: UITextView!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var text: UITextField!
    
    @IBOutlet var sent: UITextField!
    
    @IBAction func update(sender: AnyObject) {
        
        let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update3-ios.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
        
        
        // set data
        let dataString = "name=submit&id=\(todayEditId)&message=\(self.message.text!)&date=\(self.date.text!)&time=\(self.time.text!)&email=\(self.email.text!)&text=\(self.text.text!)&sent=\(self.sent.text!)&recurrent=\(futureRecurrentId)&all=no&show=yes"
        
        
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
        
        //print("message=\(futureReminders[indexPath.row])&datetime1=\(futureDate[indexPath.row])&id=\(futureDeleteId)&recurrent=\(futureRecurrentId)&all=no&show=yes&fromemail=\(parseUser)")
        
        //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        let alert = UIAlertController(title: "Update Completed.", message: "Your reminder has been updated.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            todayEditEmail = ""
            todayEditText = ""
            todayEditId = ""
            todayId = []
            todayEditReminders = ""
            todayEditDate = ""
            todayEditTime = ""
            todayEditSent = ""
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.contentSize.height = 800
        scroll.contentSize.width = 267

    }
    
    /*override func viewDidLayoutSubviews() {
     
        self.scroll.contentSize = CGSize(width: 257, height: 1000)
        
    }*/
    
    override func viewDidAppear(animated: Bool) {
        
       noInternetConnection()
    }

    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            date.text = "\(todayEditDate)"
            time.text = "\(todayEditTime)"
            message.text = "\(todayEditReminders)"
            email.text = "\(todayEditEmail)"
            text.text = "\(todayEditText)"
            sent.text = "\(todayEditSent)"
            
            print("id=\(todayEditId) message=\(todayEditReminders) date=\(todayEditDate) time=\(todayEditTime) email=\(todayEditEmail) text=\(todayEditText) timezone=\(todayEditDate) \(todayEditTime) sent=\(todayEditSent) show=yes fromemail=\(parseUser)")
            
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
