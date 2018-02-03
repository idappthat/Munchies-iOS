//
//  RecommendationManager.swift
//  Munchies
//
//  Created by Cameron Moreau on 2/2/18.
//  Copyright © 2018 Mobi. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RecommendationManager {
    
    func getRecommendation(completion: @escaping (_ recommendation: Recommendation?, _ error: String?) -> ()) {
        let headers = [
            "Authorization": "Bearer SAj8syWirG-CBcbnKYa9wpsnoquyEIVZzdERDgt7d1tk4OjrwPiCeyvRmtm2RsVvQGROru0hwO4o7A1YoPxjYBTKZ24yu-S-73X_rTKZaqvQEOLbrDx0XOm1piN2WXYx"
        ]
        let url = "https://api.yelp.com/v3/businesses/search?latitude=32.733338&longitude=-97.111425"
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let data = JSON(json)
                let select = Int(arc4random_uniform(8))
                let recommendation = Recommendation(json: data["businesses"][select])
                
                completion(recommendation,  nil)
                return
            }
            
            completion(nil, "Failed to load recommendation")
            return
        }
    }
}
