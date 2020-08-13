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
        self.distanceReading.text = "FAR"
        self.beaconMessage.text = "Tracking \(self.focusedBeacon ?? "Beacon")"
        
      case .near:
        self.view.backgroundColor = UIColor.orange
        self.distanceReading.text = "NEAR"
        self.beaconMessage.text = "Tracking \(self.focusedBeacon ?? "Beacon")"
        
      case .immediate:
        self.view.backgroundColor = UIColor.red
        self.distanceReading.text = "RIGHT HERE"
        self.beaconMessage.text = "Tracking \(self.focusedBeacon ?? "Beacon")"
        
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
        self.beaconMessage.text = "No beacon Detected"
      }
    }
  }
  
}

