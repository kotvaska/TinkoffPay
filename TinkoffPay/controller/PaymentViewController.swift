//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import UIKit
import MapKit

class PaymentViewController: BaseController<PaymentPresenter>, PaymentView {

    @IBOutlet weak var mapView: MKMapView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init() {
        super.init(nibName: "PaymentViewController", bundle: nil)

        setView(baseView: self)
        setPresenter(presenter: PaymentPresenter(view: self, paymentFacade:getInteractorManager().newPaymentFacade(),
                locationInteractor:getInteractorManager().newLocationInteractor()))

    }

    override func loadView() {
        super.loadView()

    }

}
