//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

struct PaymentAccessResponse: Codable {

    var paymentAccessList: [PaymentAccess]

    private enum CodingKeys: String, CodingKey {
        case paymentAccessList = "payload"
    }

}
