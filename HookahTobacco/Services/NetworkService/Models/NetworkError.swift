//
//  NetworkError.swift
//  HookahTobacco
//
//  Created by антон кочетков on 02.11.2022.
//

import Foundation

enum NetworkError: Error {
    // MARK: error auth
    case invalidEmail
    case wrongPassword
    case userDisabled
    case userNotFound
//    case userTokenExpired
//    case tooManyRequests

    // MARK: error database
    case dataNotFound(String)
    case permissionDenied

    // MARK: error common
    case unknownError(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        // MARK: description auth
        case .invalidEmail: return "Email не соотвествует формату"
        case .wrongPassword: return "Неверно введен пароль"
        case .userDisabled: return "Пользователь отключен"
        case .userNotFound: return "Пользователь не найден"

        // MARK: description database
        case .dataNotFound(let data): return "Данные не были найдены в базе дынных \(data)"
        case .permissionDenied: return "Доступ запрещен"

        // MARK: description common
        case .unknownError(let error): return "Неизвестная ошибка. \(error.localizedDescription)"
        }
    }
}
