//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class PaymentPresenter: BasePresenter {

    typealias V = PaymentView
    var view: V!
    var controllerTitle: String = "Точки пополнения"
    private var radius: Double = 1000

    private var paymentFacade: PaymentFacade!
    private var locationInteractor: LocationInteractor!
    private var paymentAccess: [PaymentAccess] = []

    required init(view: V) {
        self.view = view
    }

    convenience init(view: PaymentView, paymentFacade: PaymentFacade, locationInteractor: LocationInteractor) {
        self.init(view: view)
        self.paymentFacade = paymentFacade
        self.locationInteractor = locationInteractor
    }

    func viewDidLoad() {
        view.startLoading()
        view.setCurrentLocationButton()

        locationInteractor.requestCurrentLocation() { [weak self] coordinates, error in
            guard let strongSelf = self, let coordinates = coordinates, error == nil else {
                return
            }

            strongSelf.view.setRegion(radius: strongSelf.radius, latitude: coordinates.latitude, longitude: coordinates.longitude)
            strongSelf.updatePoints(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }

    }

    func updatePoints(latitude: Double, longitude: Double) {
        DispatchQueue.global(qos: .background).async() { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.paymentFacade.getPaymentAccessList(
                    latitude: latitude,
                    longitude: longitude,
                    radius: strongSelf.radius) { [weak self] models, error in
                guard let strongSelf = self else {
                    return
                }
                guard let models = models, error == nil else {
                    strongSelf.view.alertError(message: error!.localizedDescription)
                    return
                }
                strongSelf.paymentAccess = models

                DispatchQueue.main.async() {
                    strongSelf.view.setPoints(points: strongSelf.paymentAccess.compactMap({ PaymentAccessAnnotation(paymentAccess: $0) }))
                    strongSelf.view.finishLoading()
                }
            }
        }
    }

    func changeZoom(latitude: Double, longitude: Double, zoomIn: Bool) {
        radius = zoomIn ? radius - 200 : radius + 200
        updatePoints(latitude: latitude, longitude: longitude)
    }

}

