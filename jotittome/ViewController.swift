//
//  ViewController.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

//var phpId = PFObject.new().objectId
var parseUser = String()
var parseUserText = String()
var parseObjectId = String()
var emailAddresses = [String]()
var textNumbers = [String]()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
var selectedDate = String()
var selectedTime = String()
var strDate1 = String()
var defaultDateTime = NSDate()
var currentDate = NSDate()
var message = String()
var ltzName = String()
var emailActive = 0
var textActive = 0
var defaultEmailActive = 0
var defaultTextActive = 0
var btnColor = ""

var pastReminders = [String]()
var pastDate = [String]()
var pastTime = [String]()

var todayReminders = [String]()
var todayDate = [String]()
var todayTime = [String]()

var futureReminders = [String]()
var futureDate = [String]()
var futureTime = [String]()


class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var to: UITextField!

    @IBOutlet var sendEmailBtn: UIBarButtonItem!
    
    @IBOutlet var sendTextBtn: UIBarButtonItem!
    
    @IBOutlet var defaultEmailLabel: UIButton!
    
    @IBOutlet var defaultTextLabel: UIButton!
    
    @IBAction func settings(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messageToSettings", sender: self)
        
    }
    @IBAction func defaultEmail(sender: AnyObject) {
        
        if btnColor == "GreenEmail" {
            
            defaultEmailLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            defaultEmailActive = 1
                        
        } else {
        
            defaultEmailLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            defaultEmailLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Selected)
            defaultEmailActive = 1
            emailAddressesSelected = parseUser + "," + emailAddressesSelected
            btnColor = "GreenEmail"
            to.text = smsNumber + emailAddressesSelected
            print(emailAddressesSelected)
            
        }
        
    }
   
    @IBAction func defaultText(sender: AnyObject) {
        
        if btnColor == "GreenText" {
            
            defaultTextLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            defaultTextActive = 1
            
            
        } else {
            
            defaultTextLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            defaultTextLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Selected)
            defaultTextActive = 1
            smsNumber = parseUserText + "," + smsNumber
            btnColor = "GreenText"
            to.text = smsNumber + emailAddressesSelected
            print(smsNumber)
            
        }
        
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        logOut()
    }
    
    @IBAction func future(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messageToFuture", sender: self)

    }
    
    @IBAction func today(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messageToToday", sender: self)

    }
    
    @IBAction func past(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messageToPast", sender: self)

    }
    
    @IBOutlet var messageText: UITextView!
    
    @IBOutlet var messageLabel: UILabel!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        print("Message: \(message)")
        
        
        let date4 = NSDate()
        let dateFormatter4 = NSDateFormatter()
        dateFormatter4.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate1 = dateFormatter4.stringFromDate(date4)
        currentDate = dateFormatter4.dateFromString(currentDate1)!
        
        let date3 = dateFormatter4.stringFromDate(schedDateTime.date)
        defaultDateTime = dateFormatter4.dateFromString(date3)!
        print("Default Date: \(date3)")
        
        schedDateTime.date = defaultDateTime
        
    }
    
    
    @IBAction func clearAll(sender: AnyObject) {
      
        smsNumber = ""
        mmsNumber = ""
        to.text = ""
        clean = ""
        message = ""
        emailAddressesSelected = ""
        selectedDate = ""
        selectedTime = ""
        messageText.text = ""
        period = ""
        num = ""
        freq = ""
        keyboardInactive()
        emailActive = 0
        textActive = 0
        defaultEmailActive = 0
        defaultTextActive = 0
        btnColor = ""
        defaultColors()
        self.sendEmailBtn.tintColor = self.view.tintColor
        self.sendTextBtn.tintColor = self.view.tintColor
        defaultEmailLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        defaultTextLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        changeRecurrentBtnColor()
        schedDateTime.date = NSDate()
        
        let alert = UIAlertController(title: "All fields are clear!", message: "Start entering your information again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        

        
    }
    
    func defaultColors() {
        
        if emailActive == 1 {
            
            self.sendEmailBtn.tintColor = UIColor.greenColor()
            
        }
        
        if textActive == 1 {
            
            self.sendTextBtn.tintColor = UIColor.greenColor()
            
        }
        
        if defaultEmailActive == 1 {
        
            defaultEmailLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        
        }
        
        if defaultTextActive == 1 {
            
            defaultTextLabel.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            
        }
    }

    
    /*@IBAction func emailContacts(sender: AnyObject) {
        
        message = messageText.text
        println("Message: \(message)")
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        self.performSegueWithIdentifier("messageToEmail", sender: self)
        
    }
    
    @IBAction func textContacts(sender: AnyObject) {
        
        message = messageText.text
        println("Message: \(message)")
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        self.performSegueWithIdentifier("homeToTexts", sender: self)
        
    }*/
    @IBOutlet var recurrentBtn: UIButton!
    
    @IBAction func recurrent(sender: AnyObject) {
        
        message = messageText.text
        print("Message: \(message)")
        
        changeRecurrentBtnColor()
        
        //self.performSegueWithIdentifier("messageToRecurrent", sender: self)
    
    }
    
    func changeRecurrentBtnColor() {
        
        if (period == "" && freq == "") || (period == "0" && freq == "0") || (period == "0" && freq != "0") || (period != "0" && freq == "0") || (period != "0" && freq != "0") && (num == "" || num == "0") {
            
            recurrentBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        } else {
            
            recurrentBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            
        }
        
        
    }
    
    
    @IBOutlet var schedDateTime: UIDatePicker!
    
    @IBAction func datePickerAction(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        strDate1 = dateFormatter.stringFromDate(schedDateTime.date)
        //self.selectedDate.text = strDate
        
    }
    
    @IBAction func send(sender: AnyObject) {
        
        if (PFUser.currentUser() == "" || userEmail == "") {
            
            let alert = UIAlertController(title: "Error!", message: "Please login again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                self.logOut()
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
        
        
        if (emailAddressesSelected == "" && smsNumber == "" && mmsNumber == "" && to.text == "") {
            
            let alert = UIAlertController(title: "Error!", message: "You must pick an email or text contact.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            
            if (messageText.text == "") {
                
                let alert = UIAlertController(title: "Error!", message: "You must enter a message.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
            
            schedDateTime.datePickerMode = UIDatePickerMode.Date
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            selectedDate = dateFormatter1.stringFromDate(schedDateTime.date)
            print("Date: \(selectedDate)")
            
            schedDateTime.datePickerMode = UIDatePickerMode.Time
            let pickerTime = schedDateTime.date
            let time = pickerTime.dateByAddingTimeInterval(-60)
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            //selectedTime = timeFormatter.stringFromDate(schedDateTime.date)
            selectedTime = timeFormatter.stringFromDate(time)
            print("Time: \(selectedTime)")
            
        
        let url = NSURL(string:"http://www.bettersearchllc.com/Sites/Jot-it/written6.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 8.0)
        request.HTTPMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
        
            if to.text == emailAddressesSelected + smsNumber || to.text == smsNumber + emailAddressesSelected {
                
               
            } else {
                
                print(to.text)
                print(smsNumber + emailAddressesSelected)
                print(emailAddressesSelected + smsNumber)
                emailAddressesSelected = to.text!
                smsNumber = ""
                
            }
                
        // set data
        let dataString = "send1=\(messageText.text)&date1=\(selectedDate)&date2=\(selectedTime)&email1=\(emailAddressesSelected)&text=\(smsNumber)&timezone=\(selectedDate) \(selectedTime)&ltzName=\(ltzName)&userEmail=\(parseUser)&period=\(period)&recDay=\(num)&frequency=\(freq)&endDate=\(end)"
       
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
            //error = error1
            print(error1)
            reply = nil
        }
        
        let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
        print("API Response: \(results)")
            
        print("send1=\(messageText.text)&date1=\(selectedDate)&date2=\(selectedTime)&email1=\(emailAddressesSelected)&text=\(smsNumber)&timezone=\(selectedDate) \(selectedTime)&ltzName=\(ltzName)&userEmail=\(parseUser)&period=\(period)&recDay=\(num)&frequency=\(freq)&endDate=\(end)")
       
        let alert = UIAlertController(title: "Your reminder was saved.", message: "Date: \(selectedDate) \r" + "Time: \(selectedTime) \r" + "Sent to: \(emailAddressesSelected) \(smsNumber) \r" + "Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
         
            smsNumber = ""
            mmsNumber = ""
            to.text = ""
            clean = ""
            message = ""
            emailAddressesSelected = ""
            selectedDate = ""
            selectedTime = ""
            messageText.text = ""
            period = ""
            num = ""
            freq = ""
            schedDateTime.datePickerMode = UIDatePickerMode.DateAndTime
            keyboardInactive()
            emailActive = 0
            textActive = 0
            defaultEmailActive = 0
            defaultTextActive = 0
            defaultColors()
            changeRecurrentBtnColor()
            btnColor = ""
            defaultEmailLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            defaultTextLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            self.sendEmailBtn.tintColor = self.view.tintColor
            self.sendTextBtn.tintColor = self.view.tintColor
            schedDateTime.date = NSDate()
            
                 }
            }
        }
        
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
    func tapped() {
        
        let tapOnce = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboardActive))
        messageText.addGestureRecognizer(tapOnce)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = true;
        scrollView.contentSize.height = 1800
        scrollView.addSubview(messageLabel)
        scrollView.addSubview(messageText)
        scrollView.addSubview(schedDateTime)
        view.addSubview(scrollView)*/
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.keyboardActive), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.keyboardInactive), name: UIKeyboardWillHideNotification, object: nil)
        
        to.text = smsNumber + emailAddressesSelected
        
        changeRecurrentBtnColor()
        
        print(userEmail)
    }
    
    func keyboardActive() {
        
        messageLabel.text = "Tap here to lower keyboard."
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.font = messageLabel.font.fontWithSize(17)
        
    }

    func keyboardInactive() {
            
        messageLabel.text = "Enter Message"
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.font = messageLabel.font.fontWithSize(17)
        message = messageText.text
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        defaultColors()
        
        self.navigationController?.navigationBarHidden = true
        
        schedDateTime.date = defaultDateTime
        
        noInternetConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            parseUser = PFUser.currentUser()!.email!
            parseUserText = PFUser.currentUser()!["mobilePhoneCarrier"]! as! String
    
            print(parseUserText)
            
            if parseUser != "" {
                // Do stuff with the user
                print("Internet connection OK")
                
                print("View Controller: \(period) \(num) \(freq) \n\r \(end)")
                
                if (message != "") {
                    
                    messageText.text = message
                    print("Message: \(message)")
                }
                
                tzName()  // "America/Sao_Paulo"
                
                
            } else {
                // Show the signup or login screen
                
                self.performSegueWithIdentifier("homeToLogin", sender: self)
            
            }
            
            
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
    
    func tzName() {
        
        ltzName = NSTimeZone.localTimeZone().name
        //ltzName = ltzName1.stringByReplacingOccurrencesOfString("/", withString: " ")
        print("Timezone Name: \(ltzName)")
        
    }
    
    func logOut(){
        
        smsNumber = ""
        mmsNumber = ""
        to.text = ""
        clean = ""
        message = ""
        emailAddressesSelected = ""
        selectedDate = ""
        selectedTime = ""
        messageText.text = ""
        period = ""
        num = ""
        freq = ""
        schedDateTime.datePickerMode = UIDatePickerMode.DateAndTime
        keyboardInactive()
        pastReminders = []
        todayReminders = []
        futureReminders = []
        parseUser = ""
        emailActive = 0
        textActive = 0
        defaultEmailActive = 0
        defaultTextActive = 0
        defaultColors()
        btnColor = ""
        defaultEmailLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        defaultTextLabel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.sendEmailBtn.tintColor = self.view.tintColor
        self.sendTextBtn.tintColor = self.view.tintColor
        changeRecurrentBtnColor()
        schedDateTime.date = NSDate()
        
        PFUser.logOut()
        userEmail = ""
        //signupActive == true
        self.performSegueWithIdentifier("homeToLogin", sender: self)
        
    }
  
    /*override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }*/
    
}


