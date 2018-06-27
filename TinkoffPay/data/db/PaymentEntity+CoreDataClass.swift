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
public class PaymentEntity: NSManagedObject {

    static let tableName = "PaymentEntity"

    static let externalIdField = "externalId"

    convenience init(from model: PaymentAccess) {
        self.init()
        self.bankInfo = model.bankInfo
        self.externalId = model.externalId
        self.fullAddress = model.fullAddress
        self.latitude = model.location.latitude
        self.longitude = model.location.longitude
        self.partnerName = model.partnerName
        self.phones = model.phones
        self.workHours = model.workHours
    }

}
