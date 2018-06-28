//
//  PartnerEntity+CoreDataClass.swift
//  TinkoffPay
//
//  Created by Anastasia Zolotykh on 27.06.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PartnerEntity)
public class PartnerEntity: NSManagedObject {

    static let tableName = "PartnerEntity"

    static let partnerNameField = "partnerName"

    func copy(from model: Partner) {
        self.id = model.id
        self.name = model.name
        self.picture = model.picture
        self.url = model.url

    }

}
