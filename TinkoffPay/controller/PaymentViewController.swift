//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import UIKit
import MapKit

class PaymentViewController: BaseController<PaymentPresenter>, PaymentView {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonIn: UIButton!
    @IBOutlet weak var buttonOut: UIButton!

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

    func setCurrentLocationButton() {
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem
    }

    func setRegion(radius: Double, latitude: Double, longitude: Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius, radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    func setPoints(points: [PaymentAccessAnnotation]) {
        points.forEach({ mapView.addAnnotation($0) })
    }

    @IBAction func zoomIn(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
        presenter.changeZoom(latitude: region.center.latitude, longitude: region.center.longitude, zoomIn: true)
    }

    @IBAction func zoomOut(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapView.setRegion(region, animated: true)
        presenter.changeZoom(latitude: region.center.latitude, longitude: region.center.longitude, zoomIn: false)
    }


}
