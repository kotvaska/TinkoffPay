//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import CoreData

class PaymentEntityMapped: NSManagedObject {

    static let tableName = "PaymentEntity"
    static let textFieldName = "text"
    static let publicationMillisecondsFieldName = "publicationMilliseconds"
    static let idFieldName = "id"
    static let contentFieldName = "content"

}
