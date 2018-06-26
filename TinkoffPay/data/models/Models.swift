//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

struct Resource<T> {

    let url: URL
    let response: (Data) -> T?

}

struct Partner: Codable {
    let id: String
    let name: String
    let picture: String
    let url: String
}

struct PaymentAccess: Codable {
    let externalId: String
    let partnerName: String
    let workHours: String
    let phones: String
    let fullAddress: String
    let bankInfo: String
    let location: Location
    var name: String?
    var picture: String?
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
