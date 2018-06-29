//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation
import UIKit

class ImageInteractor {

    func clearIcon(iconName: String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let _ = paths.first else {
            return
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(iconName)

        do {
            try fileManager.removeItem(atPath: fileURL.path)
        } catch let error as NSError {
            print("kotvaska --- clear icon error: \(error.debugDescription)")
        } catch {
            print("kotvaska --- clear icon error")
        }
    }

    func loadImage(imageName: String?) -> UIImage? {
        if let imageName = imageName {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentsURL.appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let imageData = try Data(contentsOf: fileUrl)
                    return UIImage(data: imageData)

                } catch let e {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func getIcon(iconName: String, _ completion: (UIImage?, Error?) -> ()) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentsURL.appendingPathComponent(iconName)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let imageData = try Data(contentsOf: fileUrl)
                let image = UIImage(data: imageData)
                completion(image, nil)

            } catch let e {
                completion(nil, e)
            }
        } else {
            completion(nil, ImageStorageError(title: "Ошибка", message: "Изображение не найдено"))
        }
    }

    func saveIcon(iconName: String, oldUrl: URL) -> Data? {
        if FileManager.default.fileExists(atPath: oldUrl.path) {
            do {
                let imageData = try Data(contentsOf: oldUrl)
                if let image = UIImage(data: imageData) {
                    saveIcon(iconName: iconName, image: image)
                    return imageData
                }

            } catch let e {
                print("kotvaska --- save icon error: \(e.localizedDescription)")
                return nil
            }
        }
        return nil
    }

    func saveIcon(iconName: String, image: UIImage) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(iconName)
            let data = UIImageJPEGRepresentation(image, 1.0)
            try data?.write(to: fileURL, options: .atomic)

        } catch {

        }
    }

}
