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

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case user
        case theme
        case message
        case contents
    }
}

struct CreateAppealRequest {
    let entity: CreateAppealEntity
}

extension CreateAppealRequest {
    func createRequest() -> Moya.Task {
        if entity.contents.isEmpty {
            return .requestJSONEncodable(entity)
        }
        var formDatas: [MultipartFormData] = []
        if var dict = try? entity.asDictionary() {
            dict[CreateAppealEntity.CodingKeys.contents.rawValue] = nil
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
            let name = "\(CreateAppealEntity.CodingKeys.contents.rawValue)[\(index)]"
            formDatas.append(MultipartFormData(provider: .file(content), name: name))
        }
        return .uploadMultipart(formDatas)
    }
}

// MARK: - lList
struct AppealFilterRequest {
    let page: Int
    let themes: [ThemeAppeal]
    let status: AppealStatus?

    func createRequest() -> Moya.Task {
        var body: [String: Any] = [:]
        let urlParams: [String: Any] = [
            "page": page
        ]
        if !themes.isEmpty {
            body["themes"] = themes.map { $0.id }
        }
        if let status {
            switch status {
            case .notViewed:
                body["handled"] = false
                body["answer"] = ""
            case .processing:
                body["handled"] = false
                body["answer"] = 0
            case .handled:
                body["handled"] = true
                body["answer"] = 0
            }
        }
        return .requestCompositeParameters(bodyParameters: body,
                                           bodyEncoding: JSONEncoding.default,
                                           urlParameters: urlParams)
    }
}
