//
//  ViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 09.08.21.
//

import UIKit
import ViewAnimator
import Parse

class RestaurantTableViewController: UITableViewController {
    
    // MARK: - Properties
    var heightOfRow: CGFloat = 350
    
    let popTransitionAnimator = PopTransitionAnimator()
    
    private var restaurants = [Restaurant]()
    
    var showAnimation: Bool = false
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "FoodPin"
        
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        loadRestaurant()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animate View
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCell()
    }
    
    // MARK: - Segue to MapView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap" {
            let destinationVC = segue.destination as! MapViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    // MARK: - Dissmis MapViewController
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource
extension RestaurantTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantTableViewCell
        // Configure Cell
        
        let restaurant = restaurants[indexPath.row]
        cell.restaurantImageView.image = UIImage()
        if let restaurantImageData = restaurant.image {
            restaurantImageData.getDataInBackground { imageData, _ in
                if let imageData = imageData {
                    cell.restaurantImageView.image = UIImage(data: imageData)
                }
            }
        }
        cell.restaurantNameLabel.text = restaurant.name.uppercased()
        cell.restaurantTypeLabel.text = restaurant.location
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfRow
        
    }
    
    // MARK: - Animation
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Define initial state
        cell.alpha = 0
        
        // Define the final state (After animation)
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
    
    // MARK: - Animate View with ViewAnimator Library
    private func animateCell() {
        let animations: [Animation] = [
            AnimationType.from(direction: .bottom, offset: 300),
            AnimationType.rotate(angle: .pi / 4),
            AnimationType.zoom(scale: 3)
        ]
        
        if !showAnimation {
            UIView.animate(views: tableView.visibleCells,
                           animations: animations, duration: 1)
            showAnimation = true
        }
    }
}

// MARK: - Load Restaurant From Parse.back4App
extension RestaurantTableViewController {
    // Load restaurant from Parse
    func loadRestaurant() {
        // Clear up the array
        restaurants.removeAll(keepingCapacity: true)
        
        // Pull Data
        let query = PFQuery(className: "Restaurant")
        query.cachePolicy = PFCachePolicy.cacheElseNetwork
        query.findObjectsInBackground { (objects, error) -> Void in
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                objects.forEach { object in
                    // Convert PFObject to Restaurant object
                    let restaurant = Restaurant(pfObject: object)
                    self.restaurants.append(restaurant)
                }
            }
            
            self.tableView.reloadData()
        }
    }
}
