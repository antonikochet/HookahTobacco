//
//  TobaccoRequestDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import Moya

public struct TobaccoRequestDTO: Encodable {
    public let id: Int?
    public let name: String
    public let tastes: [Int]
    public let manufacturer: Int
    public let description: String
    public let line: Int
    public let image_url: URL?
    
    public init(
        id: Int?,
        name: String,
        tastes: [Int],
        manufacturer: Int,
        description: String,
        line: Int,
        image_url: URL?
    ) {
        self.id = id
        self.name = name
        self.tastes = tastes
        self.manufacturer = manufacturer
        self.description = description
        self.line = line
        self.image_url = image_url
    }
}

extension TobaccoRequestDTO: CreateTaskProtocol {
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
