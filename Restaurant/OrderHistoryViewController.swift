//
//  OrderHistoryViewController.swift
//  Restaurant
//
//  Created by Marc Gugliuzza on 9/24/14.
//  Copyright (c) 2014 77th Street Labs. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    let apiEndPoint = "http://rest-ordering.herokuapp.com/orders.json"
    
    var orders:[Order] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grabOrderHistory()
    }
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as OrderCollectionViewCell
        
        cell.item.text = "test"
        cell.price.text = "9999"
        
        

        return cell
    }
    
    
    func grabOrderHistory(){
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET(apiEndPoint, parameters: nil, success: {(response: HTTPResponse) -> Void in
            if response.responseObject != nil {
//                orderHistory = response.responseObject!
//                var theDict = response.responseObject! as Dictionary<String,AnyObject>
                println("example of the JSON key:")
                
                for orderJson in response.responseObject! as NSArray {
                    println("first loop: \(orderJson)")
                    for aKey in (orderJson as NSDictionary).allKeys {
                        println("second loop: \(aKey)")
                        println("value: \(orderJson[aKey])")
                    }
                }
            
                println("print the whole response: \(response.responseObject!) ")
        
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
        })
    }
    
    
}

