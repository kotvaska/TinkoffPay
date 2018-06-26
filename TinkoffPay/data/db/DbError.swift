//
// Created by Anastasia Zolotykh on 30.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

struct DbError: Error {

    var title = "Ошибка при сохранении данных"
    var message = "Произошла ошибка. Некоторые данные могут быть не сохранены"

}
