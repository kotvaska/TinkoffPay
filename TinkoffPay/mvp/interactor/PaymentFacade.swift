//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import UIKit

typealias Completion<Response: Codable> = (Response?, Error?) -> ()

class PaymentFacade {

    private let paymentAccessInteractor: PaymentAccessInteractor
    private let partnersInteractor: PartnersInteractor
    private let databaseInteractor: DatabaseInteractor
    private let imageInteractor: ImageInteractor

    init(paymentAccessInteractor: PaymentAccessInteractor, partnersInteractor: PartnersInteractor, databaseInteractor: DatabaseInteractor, imageInteractor: ImageInteractor) {
        self.paymentAccessInteractor = paymentAccessInteractor
        self.partnersInteractor = partnersInteractor
        self.databaseInteractor = databaseInteractor
        self.imageInteractor = imageInteractor
    }


    func getPartnersList(completion: Completion<[Partner]>? = nil) {
        databaseInteractor.getPartnerList() { [weak self] partners, error in
            guard let strongSelf = self, let partners = partners, error == nil else {
                completion?(nil, error)
                return
            }

            if partners.isEmpty {
                strongSelf.updatePartners(completion: completion)
            } else {
                strongSelf.updatePartnersIcons(partners: partners, completion: completion)
            }
        }

    }

    private func updatePartners(completion: Completion<[Partner]>? = nil) {
        partnersInteractor.updatePartners() { [weak self] response, error in
            guard let strongSelf = self, let response = response, error == nil else {
                completion?(nil, error)
                return
            }
            strongSelf.databaseInteractor.save(partnerList: response.partnerList, completion: nil)
            strongSelf.updatePartnersIcons(partners: response.partnerList, completion: completion)
        }
    }

    private func loadPartnerIcon(partner: Partner, completion: Completion<Partner>? = nil) {
        imageInteractor.clearIcon(iconName: partner.picture)
        partnersInteractor.updatePartnerIcon(partner: partner) { [weak self] response, error in
            guard let strongSelf = self, let response = response, let data = response.data, let image = UIImage(data: data), error == nil else {
                completion?(nil, error)
                return
            }
            strongSelf.imageInteractor.saveIcon(iconName: partner.picture, image: image)
            let partnerWithIcon = Partner(id: partner.id, name: partner.name, picture: partner.picture, url: partner.url, image: image)
            completion?(partnerWithIcon, nil)
        }
    }

    func updatePartnersIcons(partners: [Partner], completion: Completion<[Partner]>? = nil) {
        var partnersWithIcons = [Partner]()
        partners.forEach { partner in
            imageInteractor.getIcon(iconName: partner.picture) { [weak self] icon, error in
                guard let strongSelf = self, let _ = error as? ImageStorageError else {
                    return
                }

                guard let icon = icon else {
                    strongSelf.loadPartnerIcon(partner: partner) { partner, error in
                        guard let partner = partner, error == nil else {
                            return
                        }
                        partnersWithIcons.append(Partner(id: partner.id, name: partner.name, picture: partner.picture, url: partner.url, image: partner.image))
                    }
                    return
                }

                partnersWithIcons.append(Partner(id: partner.id, name: partner.name, picture: partner.picture, url: partner.url, image: icon))
            }
        }

        completion?(partnersWithIcons, nil)
    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<[PaymentAccess]>? = nil) {
        databaseInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { [weak self] paymentAccessList, error in
            guard let strongSelf = self, let paymentAccessList = paymentAccessList, error == nil else {
                completion?(nil, error)
                return
            }

            if paymentAccessList.isEmpty {
                strongSelf.updatePaymentAccessList(latitude: latitude, longitude: longitude, radius: radius)
            } else {
                completion?(paymentAccessList, error)
            }
        }

    }

    func updatePaymentAccessList(latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<[PaymentAccess]>? = nil) {
        databaseInteractor.clearAllData() { [weak self] error in
            guard let strongSelf = self, error == nil else {
                completion?(nil, error)
                return
            }

            strongSelf.getPartnersList() { partners, error in
                guard let partners = partners, error == nil else {
                    completion?(nil, error)
                    return
                }

                strongSelf.paymentAccessInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { response, error in
                    guard let response = response, error == nil else {
                        completion?(nil, error)
                        return
                    }

                    let paymentAccessList = strongSelf.getPaymentPartnerInfo(partners: partners, paymentAccessList: response.paymentAccessList)
                    strongSelf.databaseInteractor.save(paymentAccessList: response.paymentAccessList, completion: nil)
                    completion?(paymentAccessList, nil)
                }

            }

        }
    }

    private func getPaymentPartnerInfo(partners: [Partner], paymentAccessList: [PaymentAccess]) -> [PaymentAccess] {
        return paymentAccessList.map { paymentAccess -> PaymentAccess in
            if partners.contains(where: { $0.name == paymentAccess.partnerName }) {
                let partner = partners.filter({ $0.name == paymentAccess.partnerName }).first
                return PaymentAccess(externalId: paymentAccess.externalId, partnerName: paymentAccess.partnerName,
                        workHours: paymentAccess.workHours, phones: paymentAccess.phones, fullAddress: paymentAccess.fullAddress,
                        bankInfo: paymentAccess.bankInfo, location: paymentAccess.location, name: partner?.name, picture: partner?.picture)
            } else {
                return paymentAccess
            }
        }
    }

}
