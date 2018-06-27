//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import UIKit

class PartnersInteractor {

    private let mdpiBase: CGFloat = 480 / 320

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
        switch getScreenMultiplier() / mdpiBase {
        case 1:
            return "mdpi"
        case let differ where differ >= 1.5:
            return "hdpi"
        case let differ where differ >= 2:
            return "xhdpi"
        case let differ where differ >= 3:
            return "xxhdpi"
        default:
            return "mdpi"

        }

    }

    private func getScreenMultiplier() -> CGFloat {
        return UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
    }

}
