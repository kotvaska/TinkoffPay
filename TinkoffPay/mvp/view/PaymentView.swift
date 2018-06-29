//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

protocol PaymentView: BaseView {

    func setPoints(points: [PaymentAccessAnnotation])

    func setRegion(radius: Double, latitude: Double, longitude: Double)

}
