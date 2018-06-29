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
            strongSelf.databaseInteractor.save(partnerList: response.partnerList) { _ in
                strongSelf.updatePartnersIcons(partners: response.partnerList, completion: completion)
            }
        }
    }

    private func loadPartnerIcon(partner: Partner, completion: Completion<Partner>? = nil) {
        imageInteractor.clearIcon(iconName: partner.picture)
        partnersInteractor.updatePartnerIcon(partner: partner) { [weak self] response, error in
            guard let strongSelf = self, let response = response, let data = response.data, let image = UIImage(data: data), error == nil else {
                completion?(nil, error)
                return
            }

            if partner.lastModified != response.partner.lastModified {
                strongSelf.imageInteractor.saveIcon(iconName: partner.picture, image: image)
            }
            strongSelf.databaseInteractor.update(partner: response.partner) { error in
                let partnerWithIcon = Partner(id: partner.id, name: partner.name, picture: partner.picture, url: partner.url, image: image)
                completion?(partnerWithIcon, nil)
            }
        }
    }

    func updatePartnersIcons(partners: [Partner], completion: Completion<[Partner]>? = nil) {
        partners.forEach { partner in
            imageInteractor.getIcon(iconName: partner.picture) { [weak self] icon, error in
                guard let strongSelf = self, let _ = error as? ImageStorageError else {
                    return
                }

                if icon == nil {
                    DispatchQueue.global(qos: .background).async {
                        strongSelf.loadPartnerIcon(partner: partner)
                    }
                }
            }
        }
        completion?(partners, nil)

    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Double = 1000, completion: Completion<[PaymentAccess]>? = nil) {
        databaseInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { [weak self] paymentAccessList, error in
            guard let strongSelf = self, let paymentAccessList = paymentAccessList, error == nil else {
                completion?(nil, error)
                return
            }

            if paymentAccessList.isEmpty {
                strongSelf.updatePaymentAccessList(latitude: latitude, longitude: longitude, radius: radius)
            } else {
                strongSelf.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius, paymentAccessList: paymentAccessList, completion: completion)
            }
        }

    }

    private func getPaymentAccessList(latitude: Double, longitude: Double, radius: Double, paymentAccessList: [PaymentAccess], completion: Completion<[PaymentAccess]>? = nil) {
        getPartnersList() { [weak self] partners, error in
            guard let strongSelf = self, error == nil else {
                completion?(nil, error)
                return
            }

            guard let partners = partners, error == nil else {
                completion?(paymentAccessList, error)
                return
            }

            strongSelf.paymentAccessInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { response, error in
                guard let response = response, error == nil else {
                    completion?(nil, error)
                    return
                }

                let mergedPaymentAccessList = strongSelf.merge(paymentAccessList, response.paymentAccessList)
                let updatedPaymentAccessList = strongSelf.getPaymentPartnerInfo(partners: partners, paymentAccessList: mergedPaymentAccessList)
                strongSelf.databaseInteractor.save(paymentAccessList: response.paymentAccessList) { _ in
                    completion?(updatedPaymentAccessList, nil)
                }
            }

        }

    }

    func updatePaymentAccessList(latitude: Double, longitude: Double, radius: Double = 1000, completion: Completion<[PaymentAccess]>? = nil) {
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
                    strongSelf.databaseInteractor.save(paymentAccessList: response.paymentAccessList) { _ in
                        completion?(paymentAccessList, nil)
                    }
                }

            }

        }
    }

    private func merge(_ new: [PaymentAccess], _ old: [PaymentAccess]) -> [PaymentAccess] {
        var list = [PaymentAccess]()

        new.forEach { item in
            if !(list.contains(where: { $0.externalId == item.externalId }) && old.contains(where: { $0.externalId == item.externalId })) {
                list.append(item)
            }
        }

        old.forEach { item in
            if !(list.contains(where: { $0.externalId == item.externalId }) && new.contains(where: { $0.externalId == item.externalId })) {
                list.append(item)
            }
        }

        return list
    }

    private func getPaymentPartnerInfo(partners: [Partner], paymentAccessList: [PaymentAccess]) -> [PaymentAccess] {
        return paymentAccessList.map { paymentAccess -> PaymentAccess in
            if partners.contains(where: { $0.id == paymentAccess.partnerName }) {
                let partner = partners.filter({ $0.id == paymentAccess.partnerName }).first
                return PaymentAccess(externalId: paymentAccess.externalId, partnerName: paymentAccess.partnerName,
                        workHours: paymentAccess.workHours, phones: paymentAccess.phones, fullAddress: paymentAccess.fullAddress,
                        bankInfo: paymentAccess.bankInfo, location: paymentAccess.location, name: partner?.name, picture: partner?.picture)
            } else {
                return paymentAccess
            }
        }
    }

}
