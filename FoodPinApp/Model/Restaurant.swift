//
//  Restaurant.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 09.08.21.
//

import Foundation
import Parse

struct Restaurant: Hashable {
    var restaurantID = ""
    var name = ""
    var type = ""
    var location = ""
    var image: PFFileObject?
    var isVisited = false
    var phone = ""
    var rating = ""
    
    init(restaurantID: String, name: String, type: String, location: String, phone: String, image: PFFileObject!, isVisited: Bool) {
        self.restaurantID = restaurantID
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
    
    init(pfObject: PFObject) {
        self.restaurantID = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.location = pfObject["location"] as! String
        self.image = pfObject["image"] as? PFFileObject
        self.isVisited = pfObject["isVisited"] as! Bool
        self.phone = pfObject["phone"] as! String
    }
    
    func toPFObject() -> PFObject {
        let restaurantObject = PFObject(className: "Restaurant")
        restaurantObject.objectId = restaurantID
        restaurantObject["name"] = name
        restaurantObject["type"] = type
        restaurantObject["location"] = location
        restaurantObject["image"] = image
        restaurantObject["isVisited"] = isVisited
        restaurantObject["phone"] = phone
        
        return restaurantObject
    }
}
