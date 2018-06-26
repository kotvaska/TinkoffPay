//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

struct PartnerResponse: Codable {

    let partnerList: [Partner]

    private enum CodingKeys: String, CodingKey {
        case partnerList = "payload"
    }

}
