//
//  RecommendationViewController.swift
//  Munchies
//
//  Created by Cameron Moreau on 2/2/18.
//  Copyright © 2018 Mobi. All rights reserved.
//

import UIKit
import MapKit

class RecommendationViewController: UIViewController {

    @IBOutlet weak var mapSnapshot: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        generateMapSnapshot()
    }
    
    func generateMapSnapshot() {
        let mapSnapshotOptions = MKMapSnapshotOptions()

        // Bounds
        var coordinates = [CLLocationCoordinate2DMake(32.733338, -97.111425)]
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
}
