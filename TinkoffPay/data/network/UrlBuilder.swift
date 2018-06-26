//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class UrlBuilder {

    let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func partnerList() -> URL {
        return URL(string: "\(baseUrl)/v1/deposition_partners?accountType=Credit")!
    }

    func partnerIcon(dpi: String, partnerIconName: String) -> URL {
        return URL(string: "https://static.tinkoff.ru/icons/deposition-partners-v3/\(dpi)/\(partnerIconName)")!
    }

    func paymentListAll(latitude: Double, longitude: Double, radius: Int) -> URL {
        return URL(string: "\(baseUrl)/v1/deposition_points?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)")!
    }

    func paymentListPartner(partnerName: String, latitude: Double, longitude: Double, radius: Int) -> URL {
        return URL(string: "\(baseUrl)/v1/deposition_points?latitude=\(latitude)&longitude=\(longitude)&partners=\(partnerName)&radius=\(radius)")!
    }

}
