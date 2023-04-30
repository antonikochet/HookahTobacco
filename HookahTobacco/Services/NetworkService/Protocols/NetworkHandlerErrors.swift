//
//  NetworkHandlerErrors.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.04.2023.
//

import Foundation

protocol NetworkHandlerErrors {
    func handlerError(_ error: Error) -> NetworkError
}
