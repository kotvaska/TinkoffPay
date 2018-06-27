//
// Created by Anastasia Zolotykh on 30.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import CoreData

class DatabaseInteractor {

    private let dbClient: DbClient

    init(dbClient: DbClient) {
        self.dbClient = dbClient
    }

    func getPaymentAccessList(latitude: Double, longitude: Double, radius: Int, completion: Completion<[PaymentAccess]>? = nil) {
        dbClient.fetchList(tableName: PaymentEntity.tableName) { entities, error in
            guard error == nil else {
                completion?(nil, error)
                return
            }

            let accessList = entities
                    .filter({ $0 is PaymentEntity })
                    .compactMap({ $0 as? PaymentEntity })
                    .compactMap { entity in
                        PaymentAccess(externalId: entity.externalId ?? "", partnerName: entity.partnerName ?? "", workHours: entity.workHours ?? "",
                                phones: entity.phones ?? "", fullAddress: entity.fullAddress ?? "", bankInfo: entity.bankInfo ?? "",
                                location: Location(latitude: entity.latitude, longitude: entity.longitude), name: "", picture: "")
                    }

            completion?(accessList, nil)
        }

    }

    func getPartnerList(completion: Completion<[Partner]>? = nil) {
        dbClient.fetchList(tableName: PartnerEntity.tableName) { entities, error in
            guard error == nil else {
                completion?(nil, error)
                return
            }

            let partnerList = entities
                    .filter({ $0 is PartnerEntity })
                    .compactMap({ $0 as? PartnerEntity })
                    .compactMap { entity in
                        Partner(id: entity.id ?? "", name: entity.name ?? "", picture: entity.picture ?? "", url: entity.url ?? "")
                    }
            completion?(partnerList, nil)
        }
    }

    func getPartner(partnerName: String, completion: Completion<Partner>? = nil) {
        dbClient.fetchItem(tableName: PartnerEntity.tableName, partnerName: partnerName) { entity, error in
            guard let entity = entity as? PartnerEntity, error == nil else {
                completion?(nil, error)
                return
            }

            let partner = Partner(id: entity.id ?? "", name: entity.name ?? "", picture: entity.picture ?? "", url: entity.url ?? "")
            completion?(partner, nil)
        }
    }

    func save(paymentAccessList: [PaymentAccess], completion: ((Error?) -> ())?) {
        paymentAccessList.forEach {
            save(paymentAccess: $0, completion: completion)
        }
    }

    private func save(paymentAccess: PaymentAccess, completion: ((Error?) -> ())?) {
        let object = PaymentEntity(from: paymentAccess)
        dbClient.save(tableName: PaymentEntity.tableName, object: object, completion: { e in completion?(e) })
    }

    private func save(partner: Partner, completion: ((Error?) -> ())?) {
        let object = PartnerEntity(from: partner)
        dbClient.save(tableName: PartnerEntity.tableName, object: object, completion: { e in completion?(e) })
    }

    func update(paymentAccess: PaymentAccess, completion: ((Error?) -> ())?) {
        let object = PaymentEntity(from: paymentAccess)
        let predicate = NSPredicate(format: "\(PaymentEntity.externalIdField) like %@", argumentArray: [object.externalId])
        dbClient.update(tableName: PaymentEntity.tableName, object: object, predicate: predicate, completion: { e in completion?(e) })
    }

    func update(partner: Partner, completion: ((Error?) -> ())?) {
        let object = PartnerEntity(from: partner)
        let predicate = NSPredicate(format: "\(PartnerEntity.partnerNameField) like %@", argumentArray: [object.name])
        dbClient.update(tableName: PaymentEntity.tableName, object: object, predicate: predicate, completion: { e in completion?(e) })
    }

    func clearAllData(completion: @escaping (Error?) -> ()) {
        dbClient.clearAllData(tableName: PaymentEntity.tableName, completion: completion)
        dbClient.clearAllData(tableName: PartnerEntity.tableName, completion: completion)
    }

}
