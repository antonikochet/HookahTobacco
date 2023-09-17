//
//  Request+Appeals.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import Foundation
import Moya

struct CreateAppealEntity: Encodable {
    let name: String
    let email: String
    let user: Int?
    let theme: Int
    let message: String
    let contents: [URL]
}

struct CreateAppealRequest {
    let entity: CreateAppealEntity
}

extension CreateAppealRequest {
    private var contentsKey: String {
        "contents"
    }

    func createRequest() -> Moya.Task {
        if entity.contents.isEmpty {
            return .requestJSONEncodable(entity)
        }
        var formDatas: [MultipartFormData] = []
        if var dict = try? entity.asDictionary() {
            dict[contentsKey] = nil
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
        for (index, content) in entity.contents.enumerated() {
            formDatas.append(MultipartFormData(provider: .file(content), name: "\(contentsKey)[\(index)]"))
        }
        return .uploadMultipart(formDatas)
    }
}
