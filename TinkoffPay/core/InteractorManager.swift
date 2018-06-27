//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

class InteractorManager {

    private let appConfiguration: AppConfiguration

    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }

    func newPaymentAccessInteractor() -> PaymentAccessInteractor {
        return PaymentAccessInteractor(networkClient: appConfiguration.networkClient, modelSerializer: appConfiguration.modelSerializer)
    }

    func newPartnersInteractor() -> PartnersInteractor {
        return PartnersInteractor(networkClient: appConfiguration.networkClient, modelSerializer: appConfiguration.modelSerializer, imageInteractor: newImageInteractor())
    }

    func newImageInteractor() -> ImageInteractor {
        return ImageInteractor()
    }

    func newDatabaseInteractor() -> DatabaseInteractor {
        return DatabaseInteractor(dbClient: appConfiguration.dbClient)
    }

    func newPaymentFacade() -> PaymentFacade {
        return PaymentFacade(paymentAccessInteractor: newPaymentAccessInteractor(), partnersInteractor: newPartnersInteractor(), databaseInteractor: newDatabaseInteractor(), imageInteractor: newImageInteractor())
    }

    func newLocationInteractor() -> LocationInteractor {
        return LocationInteractor()
    }

}
