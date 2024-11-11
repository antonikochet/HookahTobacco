//
//  NetworkHandlerErrors.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

public protocol NetworkHandlerErrors {
    func handlerError(_ error: Error) -> ApiErrorType
}
