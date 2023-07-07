//
//  Request+Manufacturer.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.07.2023.
//

import Moya

struct ManufacturerRequest {
    private let manufacturer: Manufacturer

    init(manufacturer: Manufacturer) {
        self.manufacturer = manufacturer
    }

    func createRequest() -> Moya.Task {
        if let image = manufacturer.image {
            var formDatas: [MultipartFormData] = []
            let imageFormData = MultipartFormData(provider: .data(image),
                                                  name: Manufacturer.CodingKeys.nameImage.rawValue)
            formDatas.append(imageFormData)
            if let dict = try? manufacturer.asDictionary() {
                for (key, value) in dict {
                    let strValue = String(describing: value)
                    if let data = strValue.data(using: .utf8) {
                        formDatas.append(MultipartFormData(provider: .data(data), name: key))
                    }
                }
            }
            return .uploadMultipart(formDatas)
        } else {
            return .requestJSONEncodable(manufacturer)
        }
    }
}
