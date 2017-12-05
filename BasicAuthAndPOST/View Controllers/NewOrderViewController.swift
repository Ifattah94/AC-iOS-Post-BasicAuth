//
//  NewOrderViewController.swift
//  BasicAuthAndPOST
//
//  Created by C4Q  on 12/5/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController {

    @IBOutlet weak var orderNameTF: UITextField!
    @IBOutlet weak var orderCostTF: UITextField!
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard let orderName = self.orderNameTF.text else {
            //Display message to put order name
            return
        }
        guard let orderCostStr = self.orderCostTF.text else {
            //Display message to put order cost
            return
        }
        guard let orderCost = Int(orderCostStr) else {return}

        self.orderNameTF.text = ""
        self.orderCostTF.text = ""
        //Make POST request with orderName and orderCost
        let newOrder = Order(name: orderName, totalCost: orderCost)
        OrderAPIClient.manager.post(order: newOrder){ print($0) }
    }
}
