//
//  PaymentEntity+CoreDataClass.swift
//  TinkoffPay
//
//  Created by Anastasia Zolotykh on 27.06.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PaymentEntity)
public class PaymentEntity: NSManagedObject, CoreDataMO {

    static let tableName = "PaymentEntity"

    static let externalIdField = "externalId"

    func copy(from model: PaymentAccess) {
        self.bankInfo = model.bankInfo
        self.externalId = model.externalId
        self.fullAddress = model.fullAddress
        self.latitude = model.location.latitude
        self.longitude = model.location.longitude
        self.partnerName = model.partnerName
        self.phones = model.phones
        self.workHours = model.workHours
    }

    func copyValues(from model: CoreDataPO) {
        if let model = model as? PaymentAccess {
            copy(from: model)
        }
    }

}
