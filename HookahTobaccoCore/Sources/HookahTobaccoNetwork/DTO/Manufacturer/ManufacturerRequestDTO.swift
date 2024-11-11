//
//  ManufacturerChangeDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import Moya

public struct ManufacturerRequestDTO: Encodable {
    public let id: Int?
    public let name: String
    public let country_id: Int
    public let description: String
    public let image_url: URL?
    public let link: String?
    public let tobacco_lines: [Int]
    
    public init(
        id: Int?,
        name: String,
        country_id: Int,
        description: String,
        image_url: URL?,
        link: String?,
        tobacco_lines: [Int]
    ) {
        self.id = id
        self.name = name
        self.country_id = country_id
        self.description = description
        self.image_url = image_url
        self.link = link
        self.tobacco_lines = tobacco_lines
    }
}

extension ManufacturerRequestDTO: CreateTaskProtocol {
    func createRequest() -> Moya.Task {
        if let image_url = image_url {
            var formDatas: [MultipartFormData] = []
            let imageFormData = MultipartFormData(provider: .file(image_url),
                                                  name: "image_url")
            formDatas.append(imageFormData)
            if let dict = try? asDictionary() {
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
            return .requestJSONEncodable(self)
        }
    }
}
