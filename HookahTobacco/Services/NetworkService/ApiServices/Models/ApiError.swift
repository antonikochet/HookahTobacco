//
//  ApiError.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.04.2023.
//

import Foundation

struct ApiErrorResponse: Decodable {
    let type: String
    let errors: [ApiError]
}

enum ApiCodeError: String, Decodable {
    case detail
}

struct ApiError: Decodable {
    let code: String
    let message: String
    let fieldName: String?
    var codeError: Int?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case code = "error"
        case message
        case fieldName = "field_name"
    }
}
