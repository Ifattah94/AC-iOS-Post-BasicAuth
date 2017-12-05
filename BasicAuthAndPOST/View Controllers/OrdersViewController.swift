//
//  OrdersViewController.swift
//  BasicAuthAndPOST
//
//  Created by C4Q  on 12/5/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {

    var orders = [Order]()
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshControl.addTarget(self, action: #selector(refreshOrders(_:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
        loadOrders()
    }
    
    @objc private func refreshOrders(_ sender: Any) {
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }

    
    func loadOrders() {
        let setOrdersToOnlineOrders = {(onlineOrders: [Order]) in
            self.orders = onlineOrders
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        let printErrors = {(error: Error) in
            print(error)
            self.refreshControl.endRefreshing()
        }
        OrderAPIClient.manager.getOrders(completionHandler: setOrdersToOnlineOrders, errorHandler: printErrors)
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Order Cell", for: indexPath)
        let order = self.orders[indexPath.row]
        cell.textLabel?.text = order.name
        cell.detailTextLabel?.text = "Price: \(order.totalCost?.description ?? "None")"
        return cell
    }
}
