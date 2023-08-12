//
//  ApiAuthHandlerErrors.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

struct ApiAuthHandlerErrors: AuthHandlerErrors {
    func handlerError(_ error: Error) -> AuthError {
        return .invalidEmail
    }
}
