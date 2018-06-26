//
// Created by Maksim Kirilovskikh on 18.12.16.
// Copyright (c) 2016 chedev. All rights reserved.
//

import UIKit

protocol BaseView {

    func alertError(message: String)

    func alertOk(title: String, text: String, okAlertHandler: AlertHandler)

    func setControllerTitle(title: String)

    func setNeedsLayout()

    func layoutIfNeeded()

    func startLoading()

    func finishLoading()

}
