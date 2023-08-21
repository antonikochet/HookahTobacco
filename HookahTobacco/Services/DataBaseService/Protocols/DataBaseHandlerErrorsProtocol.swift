//
//  DataBaseHandlerErrorsProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

protocol DataBaseHandlerErrorsProtocol {
    func handlerError(_ error: Error) -> HTError
}
