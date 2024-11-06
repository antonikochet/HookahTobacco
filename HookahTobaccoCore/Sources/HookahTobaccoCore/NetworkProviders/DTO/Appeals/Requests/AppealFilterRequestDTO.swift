//
//  AppealFilterRequestDTO.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation
import Moya

struct AppealFilterRequestDTO {
    let page: Int
    let themeIds: [Int]
    let status: AppealStatus?
}

extension AppealFilterRequestDTO: CreateTaskProtocol {
    func createRequest() -> Moya.Task {
        var body: [String: Any] = [:]
        let urlParams: [String: Any] = [
            "page": page
        ]
        if !themeIds.isEmpty {
            body["themes"] = themeIds
        }
        if let status {
            switch status {
            case .notViewed:
                body["handled"] = false
                body["answer"] = ""
            case .processing:
                body["handled"] = false
                body["answer"] = 0 // TODO: - разобраться что тут происходит
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
