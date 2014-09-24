//
//  OrderHistoryViewController.swift
//  Restaurant
//
//  Created by Marc Gugliuzza on 9/24/14.
//  Copyright (c) 2014 77th Street Labs. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    let apiEndPoint = "http://rest-ordering.herokuapp.com/orders.json"
    
    var orders:[Order] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        grabOrderHistory()
        
    }
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as OrderCollectionViewCell

        var order = self.orders[indexPath.row]
        
        cell.price.text = order.orderTotal
        cell.date.text = order.createdAt
        cell.item.text = order.itemName
        
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
                
                let responseArray = response.responseObject! as NSArray
                
                for orderDict in responseArray
                {
                    var order = Order()
                    order.orderTotal = orderDict["order_total"] as String
                    
                    // get the first line item as the name
                    let lineArray = orderDict["lines"] as NSArray
                   
                    
                    for line in lineArray {
                        
                        println("line:")
                        println(line)
                        
                        order.itemName = line["name"] as String
                        order.createdAt = line["created_at"] as String
                        
                        
                            
                        
                    }
                    
                    
                    self.orders.append(order)
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.collectionView.reloadData()
                })
                
        
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
        })
    }
    
    
}

