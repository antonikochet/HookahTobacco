//
//  AuthError.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation

enum AuthError {
    // MARK: error auth
    case invalidEmail
    case wrongPassword
    case userDisabled
    case userNotFound
//    case userTokenExpired
//    case tooManyRequests
    case unknownError(Error)
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        // MARK: description auth
        case .invalidEmail: return "Email не соотвествует формату"
        case .wrongPassword: return "Неверно введен пароль"
        case .userDisabled: return "Пользователь отключен"
        case .userNotFound: return "Пользователь не найден"
        case .unknownError(let error): return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}
