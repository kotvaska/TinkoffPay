//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Resource<T> {

    let url: URL
    let response: (Data) -> T?

}

class PaymentAccessAnnotation: NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    let locationName: String
    let discipline: String

    let workHours: String?
    let phones: String?
    let fullAddress: String?
    let bankInfo: String?
    var name: String?
    var picture: String?

    init(paymentAccess: PaymentAccess) {
        self.workHours = paymentAccess.workHours
        self.phones = paymentAccess.phones
        self.fullAddress = paymentAccess.fullAddress
        self.bankInfo = paymentAccess.bankInfo
        self.name = paymentAccess.name
        self.picture = paymentAccess.picture

        self.coordinate = CLLocationCoordinate2D(latitude: paymentAccess.location.latitude, longitude: paymentAccess.location.longitude)
        title = paymentAccess.name
        subtitle = paymentAccess.fullAddress
        locationName = paymentAccess.fullAddress ?? ""
        discipline = paymentAccess.bankInfo ?? ""

        super.init()
    }

}

struct Partner: Codable, CoreDataPO {
    let id: String
    let name: String
    let picture: String
    let url: String
    var lastModified: String?
    var image: UIImage?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
        case url
    }

    init(id: String, name: String, picture: String, url: String, lastModified: String = "", image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.picture = picture
        self.url = url
        self.lastModified = lastModified
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        picture = try values.decode(String.self, forKey: .picture)
        url = try values.decode(String.self, forKey: .url)
        lastModified = nil
        image = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(picture, forKey: .picture)
        try container.encode(url, forKey: .url)
    }
}

struct PaymentAccess: Codable, CoreDataPO {
    let externalId: String
    let partnerName: String
    let workHours: String?
    let phones: String?
    let fullAddress: String?
    let bankInfo: String?
    let location: Location
    var name: String?
    var picture: String?
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
