//
// Created by Anastasia Zolotykh on 28.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import MapKit

class PaymentMapDelegate: NSObject, MKMapViewDelegate {

    private let imageInteractor: ImageInteractor

    init(imageInteractor: ImageInteractor) {
        self.imageInteractor = imageInteractor
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PaymentAccessAnnotation else { return nil }
        let annotationView = PaymentAccessAnnotationView(annotation: annotation, reuseIdentifier: PaymentAccessAnnotationView.ID)
        annotationView.image = imageInteractor.loadImage(imageName: annotation.picture)
        annotationView.canShowCallout = true
        return annotationView

    }

}
