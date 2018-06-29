//
// Created by Anastasia Zolotykh on 28.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import MapKit

class PaymentAccessAnnotationView: MKAnnotationView {

    public static let ID = "PaymentAccessAnnotationView"

    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}
