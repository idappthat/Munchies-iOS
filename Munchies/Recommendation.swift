//
//  Recommendation.swift
//  Munchies
//
//  Created by Cameron Moreau on 2/2/18.
//  Copyright © 2018 Mobi. All rights reserved.
//

import SwiftyJSON
import MapKit

class Recommendation {
    var id: String
    var name: String
    var rating: Int
    var price: String
    var category: String?
    var location: CLLocationCoordinate2D
    var imageUrl: String?
    
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.rating = json["rating"].intValue
        self.price = json["price"].stringValue
        
        // Category
        if let categories = json["categories"].array, categories.count > 0 {
            self.category = categories[0]["title"].stringValue
        }
        
        self.location = CLLocationCoordinate2DMake(json["coordinates"]["latitude"].doubleValue, json["coordinates"]["longitude"].doubleValue)
        
        self.imageUrl = json["image_url"].string
    }
}
