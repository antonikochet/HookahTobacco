//
//  CreateAppealRequestDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation
import Moya

struct CreateAppealRequestDTO: Encodable {
    let name: String
    let email: String
    let user: Int?
    let theme: Int
    let message: String
    let contents: [URL]
    
    init(entity: CreateAppealEntity) {
        self.name = entity.name
        self.email = entity.email
        self.user = entity.user
        self.theme = entity.theme
        self.message = entity.message
        self.contents = entity.contents
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case user
        case theme
        case message
        case contents
    }
}

extension CreateAppealRequestDTO: CreateTaskProtocol {
    func createRequest() -> Moya.Task {
        if contents.isEmpty {
            return .requestJSONEncodable(self)
        }
        var formDatas: [MultipartFormData] = []
        if var dict = try? asDictionary() {
            dict[CreateAppealRequestDTO.CodingKeys.contents.rawValue] = nil
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
        for (index, content) in contents.enumerated() {
            let name = "\(CreateAppealRequestDTO.CodingKeys.contents.rawValue)[\(index)]"
            formDatas.append(MultipartFormData(provider: .file(content), name: name))
        }
        return .uploadMultipart(formDatas)
    }
}
