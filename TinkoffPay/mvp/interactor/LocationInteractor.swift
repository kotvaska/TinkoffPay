//
// Created by Anastasia Zolotykh on 27.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import CoreLocation

class LocationInteractor: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var requestCurrentLocationCompletion: ((CLLocationCoordinate2D?, Error?) -> ())?

    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.delegate = self

        }

    }

    deinit {
        self.locationManager.stopUpdatingLocation()
    }

    func requestCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> ()) {
        requestCurrentLocationCompletion = completion
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        requestCurrentLocationCompletion?(locValue, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        requestCurrentLocationCompletion?(nil, error)
    }

}
