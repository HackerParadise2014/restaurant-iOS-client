//
//  ViewController.swift
//  Restaurant
//
//  Created by Marc Gugliuzza on 9/24/14.
//  Copyright (c) 2014 77th Street Labs. All rights reserved.
//

// FIGURE OUT HOW TO HIDE OTHER ROWS IN PICKER VIEW WHILE ONLY SHOW CURRENT VIEW

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    var theirMealType = 0
    
    var mealTypes = ["Breakfast", "Lunch", "Dinner", "Other"]
    
    @IBOutlet weak var menuItemName: UITextField!
    
    @IBOutlet weak var mealTypePicker: UIPickerView!
    
    @IBOutlet weak var menuItemPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mealTypePicker.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealTypes.count 
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return mealTypes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        theirMealType = row
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        
        // send data to Ruby class
        
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: "http://rest-ordering.herokuapp.com/orders"), cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
        var jsonString = "order={"
        jsonString += "\"type\":\"\(mealTypes[theirMealType])\","
        jsonString += "\"item\":\"\(menuItemName.text)\","
        jsonString += "\"price\":\"\(menuItemPrice.text)\""
        jsonString += "}"
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            println("HTTP response: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 200)
            {
                menuItemName.text = ""
                menuItemPrice.text = ""
                menuItemPrice.resignFirstResponder()
                
                var alert = UIAlertController(title: "Order submitted", message: "Your order was submitted successfully", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else
            {
                httpErrorHandler()
            }
            
            
            
            
        } else {
            println("No HTTP response")
            httpErrorHandler()
        }
        
        
        
    }
    
    func httpErrorHandler() {
        var alert = UIAlertController(title: "Failure", message: "Something went wrong :(", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

}

