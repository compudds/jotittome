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
var yesterday = Date()


class RecurrentViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var freqPicker: UIPickerView!
    
    @IBAction func back(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "recurrentToMessage", sender: self)
    }
    
    @IBOutlet var endDate: UIDatePicker! //Change end date YEAR on storyboard
    
    @IBAction func datePicked(_ sender: AnyObject) {
        
        datePickerChanged(endDate)
        
    }
    
    
    let picker = [
        ["None","Every","Every Other"],
["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],
        ["None","Days","Weeks","Months","Years"]
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){
        
        if picker[0][freqPicker.selectedRow(inComponent: 0)] == "None" {
            period = "0"
        }
        if picker[0][freqPicker.selectedRow(inComponent: 0)] == "Every" {
            period = "1"
        }
        if picker[0][freqPicker.selectedRow(inComponent: 0)] == "Every Other" {
            period = "2"
        }
        //period = picker[0][freqPicker.selectedRowInComponent(0)]
        
        num = picker[1][freqPicker.selectedRow(inComponent: 1)]
        
        if picker[2][freqPicker.selectedRow(inComponent: 2)] == "None" {
            freq = "0"
        }
        if picker[2][freqPicker.selectedRow(inComponent: 2)] == "Days" {
            freq = "1"
        }
        if picker[2][freqPicker.selectedRow(inComponent: 2)] == "Weeks" {
            freq = "7"
        }
        if picker[2][freqPicker.selectedRow(inComponent: 2)] == "Months" {
            freq = "30.45"
        }
        if picker[2][freqPicker.selectedRow(inComponent: 2)] == "Years" {
            freq = "365.24"
        }
        //freq = picker[2][freqPicker.selectedRowInComponent(2)]
        
        print("\(period) \(num) \(freq) \(end)")
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = picker[component][row]    //"\(period)" + "\(num)" + "\(freq)"
        pickerLabel.font = UIFont(name: "Helvetica", size: 17.0)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func datePickerChanged(_ endDate:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.string(from: endDate.date)
        let newDate1 = endDate.date
        let newDate = newDate1.addingTimeInterval(-1*24*60*60) //subtract a day from datepicker
        end = dateFormatter.string(from: newDate)
        print(end)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
    }

    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
