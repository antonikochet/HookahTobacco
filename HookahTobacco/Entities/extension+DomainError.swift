//
//  extension+DomainError.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation
import HookahTobaccoCore

extension DomainError {
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
        case .error(let errors):
            return errors.map({ "\($0.fieldName != nil ? $0.fieldName! + ": " : "")\($0.message)" })
                .joined(separator: "\n")
        }
    }
}

extension DomainError: Equatable {
    public static func == (lhs: DomainError, rhs: DomainError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.unexpectedError, .unexpectedError):
            return true
        case (.serverNotAvailable, .serverNotAvailable):
            return true
        case (.unknownError, .unknownError):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
