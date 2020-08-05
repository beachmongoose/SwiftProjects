//
//  ViewController.swift
//  Project16
//
//  Created by Maggie Maldjian on 8/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.mapType = MKMapType.standard
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(chooseMapType))
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    
    mapView.addAnnotations([london, oslo, paris, rome, washington])
  }
  
  @objc func chooseMapType() {
    let selectMap = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: . alert)
    selectMap.addAction(UIAlertAction(title: "Standard", style: .default, handler: { action in
      self.mapView.mapType = MKMapType.standard
    }))
    selectMap.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { action in
      self.mapView.mapType = MKMapType.satellite
    }))
    selectMap.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { action in
         self.mapView.mapType = MKMapType.hybrid
       }))
    present(selectMap, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Capital else { return nil }
    
    let identifier = "Capital"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
  
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.pinTintColor = UIColor.blue
      annotationView?.canShowCallout = true
      
      let button = UIButton(type: .detailDisclosure)
      annotationView?.rightCalloutAccessoryView = button
    } else {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.pinTintColor = UIColor.blue
      annotationView?.annotation = annotation
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let capital = view.annotation as? Capital else { return }
    
    let placeName = capital.title
    let placeInfo = capital.info
    
    let infoBox = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
      infoBox.addAction(UIAlertAction(title: "OK", style: .default))
      present(infoBox, animated: true)
  }
}

