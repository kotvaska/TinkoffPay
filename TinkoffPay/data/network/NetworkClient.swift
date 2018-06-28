//
// Created by Anastasia Zolotykh on 28.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class NetworkClient {

    private let webService: WebLoader
    private let urlBuilder: UrlBuilder
    private let modelSerializer: ModelSerializer

    init(urlBuilder: UrlBuilder, modelSerializer: ModelSerializer) {
        self.urlBuilder = urlBuilder
        webService = WebLoader()
        self.modelSerializer = modelSerializer
    }

    private func getPayload(url: URL) -> Resource<BaseResponse> {
        return Resource<BaseResponse>(url: url) { [unowned self] data in
            print("kotvaska --- url: \(url) response: \(String(data: data, encoding: .utf8))")
            var model: BaseResponse? = self.modelSerializer.deserializeToStruct(fromData: data)
            model?.payload = data
            return model
        }
    }

    func updatePaymentAccessAllList(latitude: Double, longitude: Double, radius: Int, completion: @escaping (BaseResponse?, Error?) -> ()) {
        webService.load(resource: getPayload(url: urlBuilder.paymentListAll(latitude: latitude, longitude: longitude, radius: radius)), completion: completion)
    }

    func updatePaymentAccessPartnerList(partnerName: String, latitude: Double, longitude: Double, radius: Int = 1000, completion: @escaping (BaseResponse?, Error?) -> ()) {
        webService.load(resource: getPayload(url: urlBuilder.paymentListPartner(partnerName: partnerName, latitude: latitude, longitude: longitude, radius: radius)), completion: completion)
    }

    func updatePartner(completion: @escaping (BaseResponse?, Error?) -> ()) {
        webService.load(resource: getPayload(url: urlBuilder.partnerList()), completion: completion)
    }

    func updatePartnerIcon(dpi: String, partnerIconName: String, completion: @escaping (URL?, Error?) -> ()) {
        webService.downloadImage(url: urlBuilder.partnerIcon(dpi: dpi, partnerIconName: partnerIconName), completion: completion)
    }

}
