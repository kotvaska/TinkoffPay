//
// Created by Anastasia Zolotykh on 31.01.2018.
// Copyright (c) 2018 chedev. All rights reserved.
//

import Foundation

class ModelSerializer {

    func deserializeToStruct<T: Codable>(fromJson jsonString: String) -> T? {
        if let data = jsonString.data(using: .utf8) {
            return deserializeToStruct(fromData: data)
        }

        return nil
    }

    func deserializeToStruct<T: Codable>(fromDict dict: [String: String]) -> T? {
        if let jsonData = try? JSONEncoder().encode(dict) {
            return deserializeToStruct(fromData: jsonData)
        }

        return nil
    }

    func deserializeToStruct<T: Codable>(fromData data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }

    func deserializeToDict<T: Codable>(from model: T) -> [String: String?] {
        if let dict = try? JSONDecoder().decode([String: String?].self, from: JSONEncoder().encode(model)) {
            return dict
        }
        return [:]
    }

}
