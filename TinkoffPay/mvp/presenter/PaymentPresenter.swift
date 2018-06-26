//
// Created by Anastasia Zolotykh on 29.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class PaymentPresenter: BasePresenter {

    typealias V = PaymentView
    var view: V!
    var controllerTitle: String = "Точки пополнения"

    private var paymentFacade: PaymentFacade!
    private var paymentAccess: [PaymentAccess] = []

    required init(view: V) {
        self.view = view
    }

    convenience init(view: PaymentView, paymentFacade: PaymentFacade) {
        self.init(view: view)
        self.paymentFacade = paymentFacade
    }

    func viewDidLoad() {
        view.startLoading()
        loadData(loadRequest: { _ in return paymentFacade.getPaymentAccessList(latitude: 55.755786, longitude: 37.617633, radius: 1000, completion: nil) }) {
            self.view.finishLoading()
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
            strongSelf.view.updateDataSource(news: models)
            completion()
        }
    }

    func refresh() {
        loadData(loadRequest: { _ in return paymentFacade.updatePaymentAccessList(latitude: 55.755786, longitude: 37.617633, radius: 1000, completion: nil) }) {
            self.view.hideRefreshLoader()
        }
    }

}

