//
// Created by Anastasia Zolotykh on 26.12.16.
// Copyright (c) 2016 chedev. All rights reserved.
//

import UIKit


class AlertHandler {

    let text: String
    let handler: ((UIAlertAction) -> Void)?

    init(text: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.text = text
        self.handler = handler
    }

}
