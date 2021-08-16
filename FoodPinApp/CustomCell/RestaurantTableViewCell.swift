//
//  RestaurantTableViewCell.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 16.08.21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var restaurantImageView: UIImageView! {
        didSet {
            restaurantImageView.clipsToBounds = true
            restaurantImageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var restaurantNameLabel: UILabel! {
        didSet {
            restaurantNameLabel.numberOfLines = 0
            
        }
    }
    @IBOutlet weak var restaurantTypeLabel: UILabel! {
        didSet {
            restaurantTypeLabel.numberOfLines = 0
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
