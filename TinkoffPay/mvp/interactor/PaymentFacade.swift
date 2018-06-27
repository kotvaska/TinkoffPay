//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

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
                strongSelf.loadPartnersIcons(partners: partners)
            } else {
                completion?(partners, error)
                strongSelf.updatePartnersIcons()
            }
        }

    }

    private func loadPartnersIcons(partners: [Partner]) {
        imageInteractor.clearIcons() { [weak self] in
            guard let strongSelf = self else {
                return
            }
            partners.forEach {
                strongSelf.partnersInteractor.updatePartnerIcon(partner: $0)
            }
        }
    }

    func updatePartnersIcons(completion: Completion<[Partner]>? = nil) {
        imageInteractor.getPartnersIcons() { [weak self] icons, error in
            guard let strongSelf = self, error == nil else {
                completion?(nil, error)
                return
            }

            if icons.isEmpty {
                strongSelf.partnersInteractor.updatePartners()
            } else {
                completion?(icons, error)
            }
        }

    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<[PaymentAccess]>? = nil) {
        databaseInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { [weak self] news, error in
            guard let strongSelf = self, let news = news, error == nil else {
                completion?(nil, error)
                return
            }

            if news.isEmpty {
                strongSelf.updatePaymentAccessList(latitude: latitude, longitude: longitude, radius: radius)
            } else {
                completion?(news, error)
            }
        }

    }

    func updatePaymentAccessList(latitude: Double, longitude: Double, radius: Int = 1000, completion: Completion<[PaymentAccess]>? = nil) {
        databaseInteractor.clearAllData() { [weak self] error in
            guard let strongSelf = self, error == nil else {
                completion?(nil, error)
                return
            }

            strongSelf.paymentAccessInteractor.getPaymentAccessList(latitude: latitude, longitude: longitude, radius: radius) { response, error in
                guard let response = response, error == nil else {
                    completion?(nil, error)
                    return
                }
                strongSelf.databaseInteractor.save(news: response.paymentAccessList, completion: nil)
                completion?(response.paymentAccessList, error)
            }
        }
    }

}
