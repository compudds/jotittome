//
//  RecurrentViewController.swift
//  jotittome
//
//  Created by Eric Cook on 3/25/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit

var period = String()
var num = String()
var freq = String()
var end = String()
var recDate = NSNumber()
var yesterday = NSDate()


class RecurrentViewController: UIViewController {
    
    @IBOutlet var freqPicker: UIPickerView!
    
    @IBAction func back(sender: AnyObject) {
        
        self.performSegueWithIdentifier("recurrentToMessage", sender: self)
    }
    
    @IBOutlet var endDate: UIDatePicker!
    
    @IBAction func datePicked(sender: AnyObject) {
        
        datePickerChanged(endDate)
        
    }
    
    
    let picker = [
        ["None","Every","Every Other"],
["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],
        ["None","Days","Weeks","Months","Years"]
    ]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return picker.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return picker[component][row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){
        
        if picker[0][freqPicker.selectedRowInComponent(0)] == "None" {
            period = "0"
        }
        if picker[0][freqPicker.selectedRowInComponent(0)] == "Every" {
            period = "1"
        }
        if picker[0][freqPicker.selectedRowInComponent(0)] == "Every Other" {
            period = "2"
        }
        //period = picker[0][freqPicker.selectedRowInComponent(0)]
        
        num = picker[1][freqPicker.selectedRowInComponent(1)]
        
        if picker[2][freqPicker.selectedRowInComponent(2)] == "None" {
            freq = "0"
        }
        if picker[2][freqPicker.selectedRowInComponent(2)] == "Days" {
            freq = "1"
        }
        if picker[2][freqPicker.selectedRowInComponent(2)] == "Weeks" {
            freq = "7"
        }
        if picker[2][freqPicker.selectedRowInComponent(2)] == "Months" {
            freq = "30.45"
        }
        if picker[2][freqPicker.selectedRowInComponent(2)] == "Years" {
            freq = "365.24"
        }
        //freq = picker[2][freqPicker.selectedRowInComponent(2)]
        
        print("\(period) \(num) \(freq) \(end)")
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = picker[component][row]    //"\(period)" + "\(num)" + "\(freq)"
        //pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Helvetica", size: 17.0) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func datePickerChanged(endDate:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.stringFromDate(endDate.date)
        let newDate1 = endDate.date
        let newDate = newDate1.dateByAddingTimeInterval(-1*24*60*60) //subtract a day from datepicker
        end = dateFormatter.stringFromDate(newDate)
        print(end)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
    }

    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
