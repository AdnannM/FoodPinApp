//
//  RouteTableTableViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 10.08.21.
//

import UIKit
import MapKit

class RouteTableViewController: UITableViewController {
    
    // MARK: - Properties
    var routeSteps = [MKRoute.Step]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Steps"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routeSteps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = routeSteps[indexPath.row].instructions

        return cell
    }
    
    // MARK: - Action
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
