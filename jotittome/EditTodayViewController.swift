//
//  EditTodayViewController.swift
//  jotittome
//
//  Created by Eric Cook on 6/28/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
///

import UIKit

class EditTodayViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func cancel(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "editTodayToToday", sender: self)
    }
    
    @IBOutlet var scroll: UIScrollView!
    
    @IBOutlet var date: UITextField!
    
    @IBOutlet var time: UITextField!
    
    @IBOutlet var message: UITextView!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var text: UITextField!
    
    @IBOutlet var sent: UITextField!
    
    @IBAction func update(_ sender: AnyObject) {
        
        let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update3-ios.php")
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.httpMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
        
        
        // set data
        let dataString = "name=submit&id=\(todayEditId)&message=\(self.message.text!)&date=\(self.date.text!)&time=\(self.time.text!)&email=\(self.email.text!)&text=\(self.text.text!)&sent=\(self.sent.text!)&recurrent=\(futureRecurrentId)&all=no&show=yes"
        
        
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
        
        let alert = UIAlertController(title: "Update Completed.", message: "Your reminder has been updated.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            todayEditEmail = ""
            todayEditText = ""
            todayEditId = ""
            todayId = []
            todayEditReminders = ""
            todayEditDate = ""
            todayEditTime = ""
            todayEditSent = ""
            
        }))
        
        self.present(alert, animated: true, completion: nil)

        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.contentSize.height = 900
        scroll.contentSize.width = 267
        
    }
    
    
    /*override func viewDidLayoutSubviews() {
     
        self.scroll.contentSize = CGSize(width: 257, height: 1000)
        
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
