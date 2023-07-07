//
//  Request+Tobacco.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.07.2023.
//

import Moya

struct TobaccoRequest {
    private let tobacco: Tobacco

    init(tobacco: Tobacco) {
        self.tobacco = tobacco
    }

    func createRequest() -> Moya.Task {
        if let image = tobacco.image {
            var formDatas: [MultipartFormData] = []
            let imageFormData = MultipartFormData(provider: .data(image),
                                                  name: Manufacturer.CodingKeys.nameImage.rawValue)
            formDatas.append(imageFormData)
            if let dict = try? tobacco.asDictionary() {
                for (key, value) in dict {
                    let strValue = String(describing: value)
                    if let data = strValue.data(using: .utf8) {
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
