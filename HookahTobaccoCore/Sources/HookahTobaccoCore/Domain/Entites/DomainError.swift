//
//  DomainError.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import HookahTobaccoNetwork

public enum DomainError: Error {
    case noInternetConnection
    case unexpectedError
    case serverNotAvailable
    case error([ApiError])
    case unknownError(Error)
    
    init(apiError: ApiErrorType) {
        switch apiError {
        case .noInternetConnection:
            self = .noInternetConnection
        case .unexpectedError, .encodableMapping, .parameterEncoding:
            self = .unexpectedError
        case .serverNotAvailable:
            self = .serverNotAvailable
        case .apiError(let array):
            self = .error(array.map { ApiError(dto: $0) })
        case .unknownError(let error):
            self = .unknownError(error)
        }
    }
}
