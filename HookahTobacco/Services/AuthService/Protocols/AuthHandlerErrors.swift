//
//  AuthHandlerErrors.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation

protocol AuthHandlerErrors {
    func handlerError(_ error: Error) -> AuthError
}
