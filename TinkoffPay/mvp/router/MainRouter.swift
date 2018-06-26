//
// Created by Anastasia Zolotykh on 28.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import UIKit

protocol Routing: class {
    func dismissViewController()
}

class MainRouter: Routing {

    let navigationController: UINavigationController
    let paymentAccessListViewController: PaymentViewController

    init() {
        paymentAccessListViewController = PaymentViewController()
        navigationController = UINavigationController(rootViewController: paymentAccessListViewController)
    }

    func dismissViewController() {
        navigationController.popViewController(animated: true)
    }

    func presentAlert(in controller: UIViewController, alertController: UIAlertController) {
        controller.present(alertController, animated: true)
    }

}
