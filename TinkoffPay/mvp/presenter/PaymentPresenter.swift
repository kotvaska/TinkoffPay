//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class PaymentPresenter: BasePresenter {

    typealias V = PaymentView
    var view: V!
    var controllerTitle: String = "Точки пополнения"
    private let radius = 1000

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

        locationInteractor.requestCurrentLocation() { [weak self] coordinates, error in
            guard let strongSelf = self, let coordinates = coordinates, error == nil else {
                return
            }
            strongSelf.loadData(loadRequest: { _ in
                return strongSelf.paymentFacade.getPaymentAccessList(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude,
                        radius: strongSelf.radius)
            }) {
                strongSelf.view.finishLoading()
            }
        }

    }

    private func loadData(loadRequest: (Completion<[PaymentAccess]>?) -> (), completion: @escaping () -> ()) {
        loadRequest() { [weak self] models, error in
            guard let strongSelf = self else {
                return
            }
            guard let models = models, error == nil else {
                strongSelf.view.alertError(message: error!.localizedDescription)
                return
            }
            strongSelf.paymentAccess = models
            completion()
        }
    }

}

