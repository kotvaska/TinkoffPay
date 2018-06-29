//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import UIKit
import MapKit

class PaymentViewController: BaseController<PaymentPresenter>, PaymentView {

    @IBOutlet weak var mapView: MKMapView!

    private var delegate: PaymentMapDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init() {
        super.init(nibName: "PaymentViewController", bundle: nil)

        setView(baseView: self)
        setPresenter(presenter: PaymentPresenter(view: self, paymentFacade:getInteractorManager().newPaymentFacade(),
                locationInteractor:getInteractorManager().newLocationInteractor()))

        delegate = PaymentMapDelegate(imageInteractor: getInteractorManager().newImageInteractor())

    }

    override func loadView() {
        super.loadView()
        mapView.delegate = delegate
    }

    func setRegion(radius: Double, latitude: Double, longitude: Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius, radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    func setPoints(points: [PaymentAccessAnnotation]) {
        points.forEach({ mapView.addAnnotation($0) })
    }

}
