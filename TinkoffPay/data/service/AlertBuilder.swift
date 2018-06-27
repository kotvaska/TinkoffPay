//
// Created by Anastasia Zolotykh on 22.09.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import UIKit

class AlertBuilder {

    func alertControllerWithColorButtons(title: String? = nil, message: String? = nil, okAction: AlertHandler? = nil, cancelAction: AlertHandler? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                message: message,
                preferredStyle: .alert)

        if let ok = okAction {
            let okAction = UIAlertAction(title: ok.text, style: .default, handler: ok.handler)
            okAction.setValue(UIColor.yellow, forKey: "titleTextColor")

            alertController.addAction(okAction)
            alertController.preferredAction = okAction
        }

        if let cancel = cancelAction {
            let cancelAction = UIAlertAction(title: cancel.text, style: .cancel, handler: cancel.handler)
            cancelAction.setValue(UIColor.yellow, forKey: "titleTextColor")

            alertController.addAction(cancelAction)

        }

        return alertController
    }

}
