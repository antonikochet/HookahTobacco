//
//  AppealFilterRequestDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Moya

public struct AppealFilterRequestDTO {
    let page: Int
    let themeIds: [Int]
    let status: String?
    
    public init(
        page: Int,
        themeIds: [Int],
        status: String?
    ) {
        self.page = page
        self.themeIds = themeIds
        self.status = status
    }
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
        switch status {
        case "notViewed":
            body["handled"] = false
            body["answer"] = ""
        case "processing":
            body["handled"] = false
            body["answer"] = 0
        case "handled":
            body["handled"] = true
            body["answer"] = 0
        default:
            break
        }
        return .requestCompositeParameters(bodyParameters: body,
                                           bodyEncoding: JSONEncoding.default,
                                           urlParameters: urlParams)
    }
}
