//
// Created by Anastasia Zolotykh on 29.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import Foundation

struct BaseResponse: Codable {

    let resultCode: String
    var payload: Data?

    private enum CodingKeys: String, CodingKey {
        case resultCode
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try values.decode(String.self, forKey: .resultCode)
        payload = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resultCode, forKey: .resultCode)
    }

}
