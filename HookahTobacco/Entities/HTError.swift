//
//  HTError.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 18.08.2023.
//

import Foundation
import HookahTobaccoCore

enum HTError: Error {
    case noInternetConnection
    case unexpectedError
    case serverNotAvailable
    case unknownError(Error)
    case apiError([ApiError])

    var message: String {
        switch self {
        case .noInternetConnection:
            return "Нет подключения к интернету. Проверьте подключение к сети и попробуйте снова!"
        case .unexpectedError:
            return "Произошла неизвестная ошибка!"
        case .serverNotAvailable:
            return "Сервер недоступен!"
        case .unknownError(let error):
            return "Произошла ошибка: \(error.localizedDescription)"
        case .apiError(let errors):
            return errors.map({ "\($0.fieldName != nil ? $0.fieldName! + ": " : "")\($0.message)" })
                .joined(separator: "\n")
        }
    }
    
    static func createError(_ domainError: DomainError) -> HTError {
        switch domainError {
        case .noInternetConnection:
            return .noInternetConnection
        case .unexpectedError:
            return .unexpectedError
        case .serverNotAvailable:
            return .serverNotAvailable
        case .error(let array):
            return .apiError(array.map { .init(code: $0.code, message: $0.message, fieldName: $0.fieldName) })
        case .unknownError(let error):
            return .unknownError(error)
        }
    }
}

extension HTError: Equatable {
    static func == (lhs: HTError, rhs: HTError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.unexpectedError, .unexpectedError):
            return true
        case (.unknownError, .unknownError):
            return true
        case (.apiError, .apiError):
            return true
        default:
            return false
        }
    }
}
