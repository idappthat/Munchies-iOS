//
//  RecommendationViewController.swift
//  Munchies
//
//  Created by Cameron Moreau on 2/2/18.
//  Copyright © 2018 Mobi. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage
import Cosmos

class RecommendationViewController: UIViewController {

    @IBAction func yesPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func directionsPressed(_ sender: UITapGestureRecognizer) {
        self.openMapsToRecommendation()
    }
    
    @IBOutlet weak var mapSnapshot: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeCategory: UILabel!
    @IBOutlet weak var placeDistance: UILabel!
    @IBOutlet weak var placeHours: UILabel!
    @IBOutlet weak var placePrice: UILabel!
    @IBOutlet weak var placeRating: CosmosView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var recommendationManager = RecommendationManager(location: CLLocationCoordinate2DMake(32.733338, -97.111425))
    var recommendation: Recommendation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendationManager.getRecommendation { recommendation, error in
            if let r = recommendation {
                self.recommendation = r
                self.updateMainImage(recommendation: r)
                self.updateLabels(recommendation: r)
                self.generateMapSnapshot(recommendation: r)
            }
        }
    }
    
    func updateLabels(recommendation r: Recommendation) {
        self.placeTitle.text = r.name
        self.placeCategory.text = r.category
        self.placePrice.text = r.price
        self.placeRating.rating = r.rating
        self.scrollView.layoutIfNeeded()
    }
    
    func updateMainImage(recommendation r: Recommendation) {
        guard let url = r.imageUrl else {
            return
        }
        
        // Request image
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.mainImage.image = image
            }
        }
    }
    
    func generateMapSnapshot(recommendation: Recommendation) {
        let mapSnapshotOptions = MKMapSnapshotOptions()

        // Bounds
        var coordinates = [recommendation.location]
        let polyLine = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        let region = MKCoordinateRegionForMapRect(polyLine.boundingMapRect)

        // Map Options
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: self.mapSnapshot.frame.width, height: self.mapSnapshot.frame.height)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start() { snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            self.mapSnapshot.image = snapshot.image
        }
    }
    
    // MARK: - Extra user actions
    func openMapsToRecommendation() {
        if let location = recommendation?.location {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary:nil))
            mapItem.name = recommendation?.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    // MARK: - View Config
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
