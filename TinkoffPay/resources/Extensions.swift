//
// Created by Anastasia Zolotykh on 29.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import CoreData

protocol CoreDataPO {
}

protocol CoreDataMO {
    func copyValues(from model: CoreDataPO)
}

