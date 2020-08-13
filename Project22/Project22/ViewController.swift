//
//  ViewController.swift
//  Project22
//
//  Created by Maggie Maldjian on 8/13/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  var locationManager: CLLocationManager?
  var beaconWasDetected = false
  var focusedBeacon: String?
  @IBOutlet var distanceCircle: UIView!
  @IBOutlet var distanceReading: UILabel!
  @IBOutlet var beaconMessage: UILabel!
  override func viewDidLoad() {
    
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    view.backgroundColor = .gray
    distanceCircle.layer.cornerRadius = 128
    
    super.viewDidLoad()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedAlways &&
    CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) &&
    CLLocationManager.isRangingAvailable() else { return }
    startScanning()
  }

  func startScanning() {
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "MyBeacon")
    
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    
    if let beacon = beacons.first {
      focusedBeacon = region.identifier
      if beacon.uuid == UUID(uuidString:"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") && beaconWasDetected == false {
          beaconWasDetected = true
          let beaconDetectedAlert = UIAlertController(title: "MyBeacon Detected", message: nil, preferredStyle: .alert)
          beaconDetectedAlert.addAction(UIAlertAction(title: "OK", style: .default))
          present(beaconDetectedAlert, animated: true)
      }
      update(distance: beacon.proximity)
        
    } else {
      update(distance: .unknown)
    }
  }
  
  func update(distance: CLProximity) {
    UIView.animate(withDuration: 1) {
      switch distance {
      
      case .far:
        self.view.backgroundColor = UIColor.blue
        self.showDisplay(withDistance: "FAR", circleSize: 0.3, andBGColor: UIColor.blue)
        
      case .near:
        self.showDisplay(withDistance: "NEAR", circleSize: 0.6, andBGColor: UIColor.orange)
        
      case .immediate:
        self.showDisplay(withDistance: "RIGHT HERE", circleSize: 0.9, andBGColor: UIColor.red)
        
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
        self.beaconMessage.text = "No Beacon\nDetected"
      }
    }
  }
  
  func showDisplay(withDistance text: String, circleSize num: CGFloat, andBGColor background: UIColor) {
    self.view.backgroundColor = background
    self.distanceReading.text = "\(text)"
    self.beaconMessage.text = "Tracking\n\(self.focusedBeacon ?? "Beacon")"
    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
      self.distanceCircle.transform = CGAffineTransform(scaleX: num, y: num)
    })
  
  }
}

