//
//  NetworkError.swift
//  HookahTobacco
//
//  Created by антон кочетков on 02.11.2022.
//

import Foundation

enum NetworkError: Error {
    // MARK: error database
    case dataNotFound(String)
    case permissionDenied
    case unknownDataError(String)
    case noInternetConnection
    case apiError(ApiError)

    // MARK: error common
    case unexpectedError
    case unknownError(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        // MARK: description database
        case .dataNotFound(let data): return "Данные не были найдены в базе дынных \(data)"
        case .permissionDenied: return "Доступ запрещен"
        case .unknownDataError(let coll): return "Неизвестная ошибка при получение данныех из коллекции: \(coll)"
        case .noInternetConnection: return "Доступ запрещен"
        case .apiError(let error): return error.message
        // MARK: description common
        case .unexpectedError: return "Неизвестная ошибка."
        case .unknownError(let error): return "Неизвестная ошибка. \(error.localizedDescription)"
        }
    }
}
