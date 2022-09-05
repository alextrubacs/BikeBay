//
//  BikeBayDetailViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 30/08/2022.
//

import UIKit
import MapKit

class BikePointDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Properties
    var pin: MKAnnotation!
    var currentBikePoint: TFLBikePointResponse!
    
    // MARK: Actions
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(pin.coordinate)
        createPinForMap(annotation: pin)
    }
    
    // MARK: Helper Methods
   
    
    // MARK: - MKMapview Delegate Methods
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView.animatesDrop = false
            return pinView
        }
    }
    
    func createPinForMap(annotation: MKAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

    // MARK: - CollectionView Delegate Methods
extension BikePointDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 2
        for property in currentBikePoint.additionalProperties {
            if property.key == "NbDocks" {
                count = try! Int(property.value, format: .number)
                print("There are \(property.value) bike bays")
            }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BikeCell.defaultReuseIdentifier, for: indexPath) as! BikeCell
        
        return cell
    }
    
}