//
//  RecommendationManager.swift
//  Munchies
//
//  Created by Cameron Moreau on 2/2/18.
//  Copyright © 2018 Mobi. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MapKit
import PromiseKit

class RecommendationManager {
    
    var location: CLLocationCoordinate2D
    var radius = 8046 // Meters
    var openNow = true
    
    private let headers = [
        "Authorization": "Bearer SAj8syWirG-CBcbnKYa9wpsnoquyEIVZzdERDgt7d1tk4OjrwPiCeyvRmtm2RsVvQGROru0hwO4o7A1YoPxjYBTKZ24yu-S-73X_rTKZaqvQEOLbrDx0XOm1piN2WXYx"
    ]
    
    init (location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    private func getBusinesses() -> Promise<JSON> {
        let params: [String:Any] = [
            "latitude": self.location.latitude,
            "longitude": self.location.longitude,
            "radius": self.radius,
            "open_now": self.openNow,
            "categories": "food,restaurants"
        ]
        let url = "https://api.yelp.com/v3/businesses/search"
        
        return Promise { resolve, reject in
            Alamofire.request(url, parameters: params, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    return resolve(JSON(json))
                }
                
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch businesses"])
                reject(error)
            }
        }
    }
    
    private func getBusiness(id: String) -> Promise<JSON> {
        let url = "https://api.yelp.com/v3/businesses/\(id)"
        
        return Promise { resolve, reject in
            Alamofire.request(url, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    return resolve(JSON(json))
                }
                
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch business: \(id)"])
                reject(error)
            }
        }
    }
    
    func getRecommendation(completion: @escaping (_ recommendation: Recommendation?, _ error: Error?) -> ()) {
        self.getBusinesses().then { json -> Promise<JSON> in
            let selectedIndex = Int(arc4random_uniform(8))
            let selectedBusiness = json["businesses"][selectedIndex]["id"].stringValue
            
            // Get business
            return self.getBusiness(id: selectedBusiness)
            }.then { json -> Void in
                let recommendation = Recommendation(json: json)
                completion(recommendation, nil)
            }.catch { error in
                completion(nil, error)
        }
    }
}
