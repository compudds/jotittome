//
//  EditFutureViewController.swift
//  jotittome
//
//  Created by Eric Cook on 6/28/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit

class EditFutureViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func cancel(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "editFutureToFuture", sender: self)
    }
    
    @IBOutlet var scroll: UIScrollView!
    
    @IBOutlet var date: UITextField!
    
    @IBOutlet var time: UITextField!
    
    @IBOutlet var message: UITextView!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var text: UITextField!
    
    @IBOutlet var sent: UITextField!
    
    @IBAction func update(_ sender: AnyObject) {
        
        print("Future RecurrentId: \(futureRecurrentId)")
        
        if (futureRecurrentId != "no") {
            
            let alert = UIAlertController(title: "You are editing a recurrent reminder!", message: "Do you want to edit all recurrent reminders in this set or just this one?.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "All?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update3-ios.php")
                let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 10.0)
                request.httpMethod = "POST"
                
                // set Content-Type in HTTP header
                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                
                
                // set data
                let dataString = "name=submit&id=\(futureEditId)&message=\(self.message.text!)&date=\(self.date.text!)&time=\(self.time.text!)&email=\(self.email.text!)&text=\(self.text.text!)&sent=\(self.sent.text!)&recurrent=\(futureRecurrentId)&all=yes&show=yes"
                
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
                    futureEditEmail = ""
                    futureEditText = ""
                    futureEditId = ""
                    futureId = []
                    futureEditReminders = ""
                    futureEditDate = ""
                    futureEditTime = ""
                    futureEditSent = ""
                    //futureRecurrentId = ""
                    
                }))
                
                self.present(alert, animated: true, completion: nil)

                
                
            }))
            alert.addAction(UIAlertAction(title: "This one?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update3-ios.php")
                let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
                request.httpMethod = "POST"
                
                // set Content-Type in HTTP header
                let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
                let contentType = "multipart/form-data; boundary=" + boundaryConstant
                URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
                
                
                // set data
               let dataString = "name=submit&id=\(futureEditId)&message=\(self.message.text!)&date=\(self.date.text!)&time=\(self.time.text!)&email=\(self.email.text!)&text=\(self.text.text!)&sent=\(self.sent.text!)&recurrent=\(futureRecurrentId)&all=no&show=yes"
                
                
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
                    futureEditEmail = ""
                    futureEditText = ""
                    futureEditId = ""
                    futureId = []
                    futureEditReminders = ""
                    futureEditDate = ""
                    futureEditTime = ""
                    futureEditSent = ""
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                

                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        } else {
            
            
            let url = URL(string:"http://www.bettersearchllc.com/Sites/Jot-it/update3-ios.php")
            let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            let request = NSMutableURLRequest(url: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
            request.httpMethod = "POST"
            
            // set Content-Type in HTTP header
            let boundaryConstant = "----------V2ymHFg03fssfjfnkslirt9549uvnerfhbqgZCaKO6jy";
            let contentType = "multipart/form-data; boundary=" + boundaryConstant
            URLProtocol.setProperty(contentType, forKey: "Content-Type", in: request)
            
            
            // set data
            let dataString = "name=submit&id=\(futureEditId)&message=\(message.text!)&date=\(date.text!)&time=\(time.text!)&email=\(email.text!)&text=\(text.text!)&sent=\(sent.text!)&all=no"
            
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
                futureEditEmail = ""
                futureEditText = ""
                futureEditId = ""
                futureId = []
                futureEditReminders = ""
                futureEditDate = ""
                futureEditTime = ""
                futureEditSent = ""
                
            }))
            
            self.present(alert, animated: true, completion: nil)

            
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.contentSize.height = 900
        scroll.contentSize.width = 267

    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            date.text = "\(futureEditDate)"
            time.text = "\(futureEditTime)"
            message.text = "\(futureEditReminders)"
            email.text = "\(futureEditEmail)"
            text.text = "\(futureEditText)"
            sent.text = "\(futureEditSent)"
            
            print("id=\(futureEditId) message=\(futureEditReminders) date=\(futureEditDate) time=\(futureEditTime) email=\(futureEditEmail) text=\(futureEditText) sent=\(futureEditSent) show=yes fromemail=\(parseUser) futureRecurrentId: \(futureRecurrentId)")
            
        } else {
            
            print("Internet connection FAILED")
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Jot-It To Me requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                self.noInternetConnection()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
           
        
        noInternetConnection()
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
