//
//  ViewController.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
///

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
var defaultDateTime = Date()
var currentDate = Date()
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
    
    @IBAction func settings(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "messageToSettings", sender: self)
        
    }
    @IBAction func defaultEmail(_ sender: AnyObject) {
        
        if btnColor == "GreenEmail" {
            
            defaultEmailLabel.setTitleColor(UIColor.green, for: UIControl.State())
            defaultEmailActive = 1
                        
        } else {
        
            defaultEmailLabel.setTitleColor(UIColor.green, for: UIControl.State())
            defaultEmailLabel.setTitleColor(UIColor.green, for: UIControl.State.selected)
            defaultEmailActive = 1
            emailAddressesSelected = parseUser + "," + emailAddressesSelected
            btnColor = "GreenEmail"
            to.text = smsNumber + emailAddressesSelected
            print(emailAddressesSelected)
            
        }
        
    }
   
    @IBAction func defaultText(_ sender: AnyObject) {
        
        if btnColor == "GreenText" {
            
            defaultTextLabel.setTitleColor(UIColor.green, for: UIControl.State())
            defaultTextActive = 1
            
            
        } else {
            
            defaultTextLabel.setTitleColor(UIColor.green, for: UIControl.State())
            defaultTextLabel.setTitleColor(UIColor.green, for: UIControl.State.selected)
            defaultTextActive = 1
            smsNumber = parseUserText + "," + smsNumber
            btnColor = "GreenText"
            to.text = smsNumber + emailAddressesSelected
            print(smsNumber)
            
        }
        
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        
        logOut()
    }
    
    @IBAction func future(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "messageToFuture", sender: self)

    }
    
    @IBAction func today(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "messageToToday", sender: self)

    }
    
    @IBAction func past(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "messageToPast", sender: self)

    }
    
    @IBOutlet var messageText: UITextView!
    
    @IBOutlet var messageLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        
        print("Message: \(message)")
        
        
        let date4 = Date()
        let dateFormatter4 = DateFormatter()
        dateFormatter4.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate1 = dateFormatter4.string(from: date4)
        currentDate = dateFormatter4.date(from: currentDate1)!
        
        let date3 = dateFormatter4.string(from: schedDateTime.date)
        defaultDateTime = dateFormatter4.date(from: date3)!
        print("Default Date: \(date3)")
        
        schedDateTime.date = defaultDateTime
        
    }
    
    
    @IBAction func clearAll(_ sender: AnyObject) {
      
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
        defaultEmailLabel.setTitleColor(UIColor.red, for: UIControl.State())
        defaultTextLabel.setTitleColor(UIColor.red, for: UIControl.State())
        changeRecurrentBtnColor()
        schedDateTime.date = Date()
        ema1 = []
        ema = ""
        text1 = []
        countTextNumbers = 0
        countEmailAddresses = 0
        
        let alert = UIAlertController(title: "All fields are clear!", message: "Start entering your information again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        

        
    }
    
    func defaultColors() {
        
        if emailActive == 1 {
            
            self.sendEmailBtn.tintColor = UIColor.green
            
            /*for address in ema1 {
            
                alertForMultipleEmails(address: address)
                
                print(address)
                
            }*/
        }
        
        if textActive == 1 {
            
            self.sendTextBtn.tintColor = UIColor.green
            
        }
        
        if defaultEmailActive == 1 {
        
            defaultEmailLabel.setTitleColor(UIColor.green, for: UIControl.State())
        
        }
        
        if defaultTextActive == 1 {
            
            defaultTextLabel.setTitleColor(UIColor.green, for: UIControl.State())
            
        }
    }
    
    /*func alertForMultipleEmails(address: String) {
        
        print(ema1.count)
        print(ema1)
        
        if countEmailAddresses > 1 {
            
            if ema1 != [] {
                
                
            //for i in 0..<ema1.count {
            //for address in ema1 {
                
                //let alert = UIAlertController(title: "Multiple emails exist for this contact.", message: "Did you want this one? \r\r \(ema1[i])", preferredStyle: UIAlertControllerStyle.alert)
                
                print(address)
                
                let alert = UIAlertController(title: "Multiple emails exist for this contact.", message: "Did you want this one? \r \(address)", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    emailActive = 1
                    
                    //emailAddressesSelected = ema1[i] + "," + emailAddressesSelected
                    
                    emailAddressesSelected = address + "," + emailAddressesSelected
                    
                    self.to.text = smsNumber + emailAddressesSelected
                    
                    //self.performSegue(withIdentifier: "backToHome", sender: self)
                    
                    ema1 = []
                    
                }))
                
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "backToHome", sender: self)
                    print(ema1)
                    
                    if emailAddressesSelected == "" {
                        
                        emailActive = 0
                        
                        self.sendEmailBtn.tintColor = UIColor.blue
                        
                    }
                    
                    ema1 = []
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
              //}
                
            }
            
        }
        
    }*/
    

    
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
    
    @IBAction func recurrent(_ sender: AnyObject) {
        
        message = messageText.text
        print("Message: \(message)")
        
        changeRecurrentBtnColor()
        
        self.performSegue(withIdentifier: "messageToRecurrent", sender: self)
    
    }
    
    func changeRecurrentBtnColor() {
        
        if (period == "" && freq == "") || (period == "0" && freq == "0") || (period == "0" && freq != "0") || (period != "0" && freq == "0") || (period != "0" && freq != "0") && (num == "" || num == "0") {
            
            recurrentBtn.setTitleColor(UIColor.white, for: UIControl.State())
            
        } else {
            
            recurrentBtn.setTitleColor(UIColor.green, for: UIControl.State())
            
        }
        
        
    }
    
    
    @IBOutlet var schedDateTime: UIDatePicker!
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        strDate1 = dateFormatter.string(from: schedDateTime.date)
        //selectedDate = strDate1
        
    }
    
    @IBAction func send(_ sender: AnyObject) {
        
        if (PFUser.current() == nil || userEmail == "") {
            
            let alert = UIAlertController(title: "Error!", message: "Please login again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.logOut()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
        
        if (emailAddressesSelected == "" && smsNumber == "" && mmsNumber == "" && to.text == "") {
            
            let alert = UIAlertController(title: "Error!", message: "You must pick an email or text contact.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            if (messageText.text == "") {
                
                let alert = UIAlertController(title: "Error!", message: "You must enter a message.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
            
            schedDateTime.datePickerMode = UIDatePicker.Mode.date
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            selectedDate = dateFormatter1.string(from: schedDateTime.date)
            print("Date: \(selectedDate)")
            
            schedDateTime.datePickerMode = UIDatePicker.Mode.time
            let pickerTime = schedDateTime.date
            let time = pickerTime.addingTimeInterval(-60)
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            //selectedTime = timeFormatter.stringFromDate(schedDateTime.date)
            selectedTime = timeFormatter.string(from: time)
            print("Time: \(selectedTime)")
            
        
        let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/written6.php")
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 8.0)
        request.httpMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
        
            if to.text == emailAddressesSelected + smsNumber || to.text == smsNumber + emailAddressesSelected {
                
               
            } else {
                
                print(to.text!)
                print(smsNumber + emailAddressesSelected)
                print(emailAddressesSelected + smsNumber)
                emailAddressesSelected = to.text!
                smsNumber = ""
                
            }
                
        // set data
        let dataString = "send1=\(messageText.text!)&date1=\(selectedDate)&date2=\(selectedTime)&email1=\(emailAddressesSelected)&text=\(smsNumber)&timezone=\(selectedDate) \(selectedTime)&ltzName=\(ltzName)&userEmail=\(parseUser)&userText=\(parseUserText)&period=\(period)&recDay=\(num)&frequency=\(freq)&endDate=\(end)"
       
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
        
        // set content length
            
        //var response: URLResponse? = nil
        
        //var reply: Data?
                
        //do {
            
            
            
            //reply = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
                
           //dataTaskWithRequest:completionHandler:]
        /*} catch let error as NSError {
            
            print(error)
            
            reply = nil
        }
        
        let results = NSString(data:reply!, encoding:String.Encoding.utf8.rawValue)
        print("API Response: \(String(describing: results))")*/
            
        print("send1=\(messageText.text!)&date1=\(selectedDate)&date2=\(selectedTime)&email1=\(emailAddressesSelected)&text=\(smsNumber)&timezone=\(selectedDate) \(selectedTime)&ltzName=\(ltzName)&userEmail=\(parseUser)&period=\(period)&recDay=\(num)&frequency=\(freq)&endDate=\(end)")
       
        let alert = UIAlertController(title: "Your reminder was saved.", message: "Date: \(selectedDate) \r" + "Time: \(selectedTime) \r" + "Sent to: \(emailAddressesSelected) \(smsNumber) \r" + "Thank you!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
         
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
            schedDateTime.datePickerMode = UIDatePicker.Mode.dateAndTime
            keyboardInactive()
            emailActive = 0
            textActive = 0
            defaultEmailActive = 0
            defaultTextActive = 0
            defaultColors()
            changeRecurrentBtnColor()
            btnColor = ""
            defaultEmailLabel.setTitleColor(UIColor.red, for: UIControl.State())
            defaultTextLabel.setTitleColor(UIColor.red, for: UIControl.State())
            self.sendEmailBtn.tintColor = self.view.tintColor
            self.sendTextBtn.tintColor = self.view.tintColor
            schedDateTime.date = Date()
            
                 }
            }
        }
        
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func tapped() {
        
        let tapOnce = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboardActive))
        messageText.addGestureRecognizer(tapOnce)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.keyboardActive), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.keyboardInactive), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        to.text = smsNumber + emailAddressesSelected
        
        changeRecurrentBtnColor()
        
        print("User Email: \(userEmail)")
        
    }
    
    @objc func keyboardActive() {
        
        messageLabel.text = "Tap here to lower keyboard."
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.font = messageLabel.font.withSize(17)
        
    }

    @objc func keyboardInactive() {
            
        messageLabel.text = "Enter Message"
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.font = messageLabel.font.withSize(17)
        message = messageText.text
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        defaultColors()
        
        self.navigationController?.isNavigationBarHidden = true
        
        schedDateTime.date = defaultDateTime
        
        if (userEmail.count > 0 || userEmail != "") {
            
            noInternetConnection()
            
        } else {
            
            self.performSegue(withIdentifier: "homeToLogin", sender: self)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print("View Controller: \(period) \(num) \(freq) \n\r \(end)")
            
            parseUser = PFUser.current()!.email!
            parseUserText = PFUser.current()!["mobilePhoneCarrier"]! as! String
            
            print("Parse User: \(parseUser)")
            print("Parse User Text: \(parseUserText)")
            
            if (message != "") {
                
                messageText.text = message
                print("Message: \(message)")
            }
            
            tzName()  // "America/Sao_Paulo"
            
            
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
    
    func tzName() {
        
        ltzName = TimeZone.autoupdatingCurrent.identifier
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
        schedDateTime.datePickerMode = UIDatePicker.Mode.dateAndTime
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
        defaultEmailLabel.setTitleColor(UIColor.red, for: UIControl.State())
        defaultTextLabel.setTitleColor(UIColor.red, for: UIControl.State())
        self.sendEmailBtn.tintColor = self.view.tintColor
        self.sendTextBtn.tintColor = self.view.tintColor
        changeRecurrentBtnColor()
        schedDateTime.date = Date()
        
        PFUser.logOut()
        userEmail = ""
        //signupActive == true
        self.performSegue(withIdentifier: "homeToLogin", sender: self)
        
    }
  
    /*override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }*/
    
}


