//
//  ViewController.swift
//  TestBeacon
//
//  Created by Ellan Esenaliev on 2/5/20.
//  Copyright © 2020 Ellan Esenaliev. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    var locationManage: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManage = CLLocationManager()
        locationManage?.delegate = self
        locationManage?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        // Это тоже самое, просто вот то что закоментированно
        // CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        // Depricated просто уже
        let contraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: contraint, identifier: "MyBeacon")
        
        locationManage?.startMonitoring(for: beaconRegion)
        //тут тоже уже устарело
        //locationManage?.startRangingBeacons(in: beaconRegion)
        locationManage?.startRangingBeacons(satisfying: contraint)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
                
            case .far:
                self.titleLabel.text = "FAR"
                self.view.backgroundColor = UIColor.blue

            case .near:
                self.titleLabel.text = "NEAR"
                self.view.backgroundColor = UIColor.orange

            case .immediate:
                self.titleLabel.text = "IMMEDIATE"
                self.view.backgroundColor = UIColor.red
                
            default:
                self.view.backgroundColor = UIColor.gray

            }
        }
    }
}

