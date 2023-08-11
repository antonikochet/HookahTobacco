//
//  Request+Manufacturer.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.07.2023.
//

import Foundation
import Moya

struct ManufacturerRequest {
    private let manufacturer: Manufacturer

    init(manufacturer: Manufacturer) {
        self.manufacturer = manufacturer
    }

    func createRequest() -> Moya.Task {
        if let image = manufacturer.image {
            let format = ImageFormat.get(from: image)
            var formDatas: [MultipartFormData] = []
            let imageFormData = MultipartFormData(provider: .data(image),
                                                  name: Manufacturer.CodingKeys.nameImage.rawValue,
                                                  fileName: "image.\(format.rawValue)",
                                                  mimeType: format.rawValue)
            formDatas.append(imageFormData)
            if let dict = try? manufacturer.asDictionary() {
                for (key, value) in dict {
                    var data: Data?
                    if let arrayValue = value as? [Any] {
                        data = arrayValue.map({ "\($0)"}).joined(separator: ", ").data(using: .utf8)
                    } else {
                        data = "\(value)".data(using: .utf8)
                    }
                    if let data {
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
