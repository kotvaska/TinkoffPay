//
// Created by Anastasia Zolotykh on 29.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataPO {
}

protocol CoreDataMO {
    func copyValues(from model: CoreDataPO)
}

extension UIImage {

    func resize(canvasSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, self.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        self.draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}