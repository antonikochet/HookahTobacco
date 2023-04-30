//
//  ApiError.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.04.2023.
//

import Foundation

enum ApiCodeError: String, Decodable {
    case detail
}

struct ApiError: Decodable {
    let code: ApiCodeError
    let message: String
    var codeError: Int?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message = "detail"
    }
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        message
    }
}
