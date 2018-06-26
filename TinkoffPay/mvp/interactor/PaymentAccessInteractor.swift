//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class PaymentAccessInteractor {

    private let networkClient: NetworkClient
    private let modelSerializer: ModelSerializer

    init(networkClient: NetworkClient, modelSerializer: ModelSerializer) {
        self.networkClient = networkClient
        self.modelSerializer = modelSerializer
    }

    func getPartnerPaymentAccessList(partnerName: String, latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<PaymentAccessResponse>? = nil) {
        networkClient.updatePaymentAccessPartnerList(partnerName: partnerName, latitude: latitude, longitude: longitude, radius: radius) { [weak self] payload, error in
            guard let strongSelf = self,
                  error == nil,
                  let payload = payload?.payload,
                  let response: PaymentAccessResponse = strongSelf.modelSerializer.deserializeToStruct(fromData: payload) else {
                completion?(nil, error)
                return
            }

            DispatchQueue.main.async {
                completion?(response, nil)
            }
        }
    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<PaymentAccessResponse>? = nil) {
        networkClient.updatePaymentAccessAllList(latitude: latitude, longitude: longitude, radius: radius) { [weak self] payload, error in
            guard let strongSelf = self,
                  error == nil,
                  let payload = payload?.payload,
                  let response: PaymentAccessResponse = strongSelf.modelSerializer.deserializeToStruct(fromData: payload) else {
                completion?(nil, error)
                return
            }

            DispatchQueue.main.async {
                completion?(response, nil)
            }
        }
    }

}
