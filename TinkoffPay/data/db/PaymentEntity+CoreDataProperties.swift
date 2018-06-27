//
//  PaymentEntity+CoreDataProperties.swift
//  TinkoffPay
//
//  Created by Anastasia Zolotykh on 27.06.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//
//

import Foundation
import CoreData


extension PaymentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentEntity> {
        return NSFetchRequest<PaymentEntity>(entityName: "PaymentEntity")
    }

    @NSManaged public var bankInfo: String?
    @NSManaged public var externalId: String?
    @NSManaged public var fullAddress: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var partnerName: String?
    @NSManaged public var phones: String?
    @NSManaged public var workHours: String?

}
