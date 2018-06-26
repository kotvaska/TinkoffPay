//
// Created by Anastasia Zolotykh on 29.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

protocol PaymentView: BaseView {

    func hideRefreshLoader()

    func updateDataSource(news: [PaymentAccess])

}
