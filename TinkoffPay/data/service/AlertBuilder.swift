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

        let subView = alertController.view.subviews.first! as UIView
        let view = subView.subviews.first! as UIView

        subView.backgroundColor = .white
        view.backgroundColor = .white
        subView.layer.cornerRadius = 30
        view.layer.cornerRadius = 30

        if let ok = okAction {
            let okAction = UIAlertAction(title: ok.text, style: .default, handler: ok.handler)
            okAction.setValue(UIColor(red: 20 / 255.0, green: 167 / 255.0, blue: 199 / 255.0, alpha: 1.0), forKey: "titleTextColor")

            alertController.addAction(okAction)
            alertController.preferredAction = okAction
        }

        if let cancel = cancelAction {
            let cancelAction = UIAlertAction(title: cancel.text, style: .cancel, handler: cancel.handler)
            cancelAction.setValue(UIColor(red: 20 / 255.0, green: 167 / 255.0, blue: 199 / 255.0, alpha: 1.0), forKey: "titleTextColor")

            alertController.addAction(cancelAction)

        }

        return alertController
    }

}
