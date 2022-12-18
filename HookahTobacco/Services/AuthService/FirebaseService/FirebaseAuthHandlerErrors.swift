//
//  FirebaseAuthHandlerErrors.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthHandlerErrors: AuthHandlerErrors {
    func handlerError(_ error: Error) -> AuthError {
        handlerAuthError(error as NSError) ?? .unknownError(error)
    }

    private func handlerAuthError(_ nsError: NSError) -> AuthError? {
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:          return .wrongPassword
        case AuthErrorCode.invalidEmail.rawValue:           return .invalidEmail
        case AuthErrorCode.userDisabled.rawValue:           return .userDisabled
        case AuthErrorCode.userNotFound.rawValue:           return .userNotFound

        default:                                            return nil
        }
    }
}
