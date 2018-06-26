//
// Created by Anastasia Zolotykh on 30.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

// TODO:
class DatabaseInteractor {

    private let dbClient: DbClient

    init(dbClient: DbClient) {
        self.dbClient = dbClient
    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Int, completion: Completion<[PaymentAccess]>? = nil) {
        dbClient.fetchList(tableName: PaymentEntityMapped.tableName) { entities, error in
            guard error == nil else {
                completion?(nil, error)
                return
            }

            let accessList = entities.flatMap { entity in
                PaymentAccess(externalId: <#T##String##Swift.String#>, partnerName: <#T##String##Swift.String#>, workHours: <#T##String##Swift.String#>, phones: <#T##String##Swift.String#>, fullAddress: <#T##String##Swift.String#>, bankInfo: <#T##String##Swift.String#>, location: <#T##Location##TinkoffPay.Location#>, name: <#T##String?##Swift.String?#>, picture: <#T##String?##Swift.String?#>)
            }
            completion?(accessList, nil)

        }
    }

    func getPartnerList(completion: Completion<[Partner]>? = nil) {
        dbClient.fetchList(tableName: PartnerEntityMapped.tableName) { entities, error in
            guard error == nil else {
                completion?(nil, error)
                return
            }

            let partnerList = entities.flatMap { entity in
                Partner(id: <#T##String##Swift.String#>, name: <#T##String##Swift.String#>, picture: <#T##String##Swift.String#>, url: <#T##String##Swift.String#>)
            }
            completion?(partnerList, nil)
        }
    }

    func getPartner(partnerName: String, completion: Completion<PaymentAccess>? = nil) {
        dbClient.fetchItem(tableName: PartnerEntityMapped.tableName, partnerName: partnerName) { entity, error in
            guard let entity = entity, error == nil else {
                completion?(nil, error)
                return
            }

            let access = PaymentAccess(externalId: <#T##String##Swift.String#>, partnerName: <#T##String##Swift.String#>, workHours: <#T##String##Swift.String#>, phones: <#T##String##Swift.String#>, fullAddress: <#T##String##Swift.String#>, bankInfo: <#T##String##Swift.String#>, location: <#T##Location##TinkoffPay.Location#>, name: <#T##String?##Swift.String?#>, picture: <#T##String?##Swift.String?#>)
            completion?(access, nil)
        }
    }

    func save(news: [PaymentAccess], completion: ((Error?) -> ())?) {
        news.forEach {
            save(news: $0, completion: completion)
        }
    }

    private func save(news: PaymentAccess, completion: ((Error?) -> ())?) {
        // TODO: dbClient.save(tableName: PaymentEntityMapped.tableName, object: news, completion: { e in completion?(e) })
    }

    func update(news: PaymentAccess, completion: ((Error?) -> ())?) {
        // TODO: dbClient.update(tableName: PaymentEntityMapped.tableName, news: news, completion: { e in completion?(e) })
    }

    func clearAllData(completion: @escaping (Error?) -> ()) {
        dbClient.clearAllData(tableName: PaymentEntityMapped.tableName, completion: completion)
        dbClient.clearAllData(tableName: PartnerEntityMapped.tableName, completion: completion)
    }

}
