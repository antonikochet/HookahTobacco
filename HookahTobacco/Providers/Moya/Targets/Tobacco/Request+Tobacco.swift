//
//  Request+Tobacco.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.07.2023.
//

import Moya
import Foundation

struct TobaccoRequest {
    private let tobacco: Tobacco

    init(tobacco: Tobacco) {
        self.tobacco = tobacco
    }

    func createRequest() -> Moya.Task {
        if let image = tobacco.image {
            let format = ImageFormat.get(from: image)
            var formDatas: [MultipartFormData] = []
            let imageFormData = MultipartFormData(provider: .data(image),
                                                  name: Tobacco.CodingKeys.imageURL.rawValue,
                                                  fileName: "image.\(format.rawValue)",
                                                  mimeType: format.contentType)
            formDatas.append(imageFormData)
            if let dict = try? tobacco.asDictionary() {
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
            return .requestJSONEncodable(tobacco)
        }
    }
}

typealias ArrayId = [Int]

struct TobaccoFilterRequest: Encodable {
    let manufacturer: ArrayId?
    let tasteType: ArrayId?
    let tastes: ArrayId?
    let tobaccoType: ArrayId?

    enum CodingKeys: String, CodingKey {
        case manufacturer
        case tasteType = "taste_type"
        case tastes
        case tobaccoType = "tobacco_type"
    }
}

extension TobaccoFilterRequest {
    init?(_ filters: TobaccoFilters?) {
        guard let filters else { return nil }
        manufacturer = filters.manufacturer.isEmpty ? nil : filters.manufacturer.map { $0.id }
        tasteType = filters.tasteType.isEmpty ? nil : filters.tasteType.map { $0.uid }
        tastes = filters.tastes.isEmpty ? nil : filters.tastes.map { $0.id }
        tobaccoType = filters.tobaccoType.isEmpty ? nil : filters.tobaccoType.map { $0.rawValue }
    }
}
