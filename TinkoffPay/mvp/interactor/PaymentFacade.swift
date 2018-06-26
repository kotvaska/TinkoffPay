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

    init(paymentAccessInteractor: PaymentAccessInteractor, partnersInteractor: PartnersInteractor, databaseInteractor: DatabaseInteractor) {
        self.paymentAccessInteractor = paymentAccessInteractor
        self.partnersInteractor = partnersInteractor
        self.databaseInteractor = databaseInteractor
    }


    func getPartnersList(completion: Completion<[Partner]>? = nil) {
        databaseInteractor.getPartnerList() { [weak self] news, error in
            guard let strongSelf = self, let news = news, error == nil else {
                completion?(nil, error)
                return
            }

            if news.isEmpty {
                strongSelf.updatePartnersIcons()
            } else {
                completion?(news, error)
            }
        }

    }

    func updatePartnersIcons(completion: Completion<[Partner]>? = nil) {
        // TODO:
//        databaseInteractor.getPartnersIcons() { [weak self] icons, error in
//            guard let strongSelf = self, let icons = icons, error == nil else {
//                completion?(nil, error)
//                return
//            }
//
//            if icons.isEmpty {
//                strongSelf.partnersInteractor.updatePartners()
//            } else {
//                completion?(icons, error)
//            }
//        }

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
