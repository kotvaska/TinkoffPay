//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class PartnersInteractor {

    private let networkClient: NetworkClient
    private let modelSerializer: ModelSerializer
    private let imageInteractor: ImageInteractor

    init(networkClient: NetworkClient, modelSerializer: ModelSerializer, imageInteractor: ImageInteractor) {
        self.networkClient = networkClient
        self.modelSerializer = modelSerializer
        self.imageInteractor = imageInteractor
    }

    func updatePartners(completion: Completion<PartnerResponse>? = nil) {
        networkClient.updatePartner() { [weak self] payload, error in
            guard let strongSelf = self,
                  error == nil,
                  let payload = payload?.payload,
                  let response: PartnerResponse = strongSelf.modelSerializer.deserializeToStruct(fromData: payload) else {
                completion?(nil, error)
                return
            }

            // TODO: update icons

            DispatchQueue.main.async {
                completion?(response, nil)
            }
        }
    }

    func updatePartnerIcon(partner: Partner, completion: Completion<PartnerResponse>? = nil) {
        networkClient.updatePartnerIcon(dpi: getDpi(), partnerIconName: partner.picture) { payload, error in
            DispatchQueue.main.async {
                completion?(nil, nil)
            }
        }
    }

    private func getDpi() -> String {
        return "mdpi"
    }
}
