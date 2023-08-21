//
//  HTError.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 18.08.2023.
//

import Foundation

enum HTError: Error {
    case noInternetConnection
    case unexpectedError
    case unknownError(Error)
    case apiError([ApiError])
    case databaseError(DataBaseError)

    var message: String {
        switch self {
        case .noInternetConnection:
            return "Нет подключения к интернету. Проверьте подключение к сети и попробуйте снова!"
        case .unexpectedError:
            return "Произошла неизвестная ошибка!"
        case .unknownError(let error):
            return "Произошла ошибка: \(error.localizedDescription)"
        case .apiError(let errors):
            return errors.map({ "\($0.fieldName != nil ? $0.fieldName! + ": " : "")\($0.message)" })
                .joined(separator: "\n")
        case .databaseError(let error):
            return error.errorDescription ?? ""
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
        case (.databaseError, .databaseError):
            return true
        default:
            return false
        }
    }
}
