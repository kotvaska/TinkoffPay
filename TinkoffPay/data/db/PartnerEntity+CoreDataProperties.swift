//
//  PartnerEntity+CoreDataProperties.swift
//  TinkoffPay
//
//  Created by Anastasia Zolotykh on 27.06.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//
//

import Foundation
import CoreData


extension PartnerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PartnerEntity> {
        return NSFetchRequest<PartnerEntity>(entityName: "PartnerEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var picture: String?
    @NSManaged public var url: String?
    @NSManaged public var lastModified: String?

}
