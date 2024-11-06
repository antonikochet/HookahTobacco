//
//  DomainError.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

public enum DomainError: Error {
    case noInternetConnection
    case unexpectedError
    case serverNotAvailable
    case encodableMapping(Error)
    case parameterEncoding(Error)
    case error([ApiError])
    case unknownError(Error)
    
    var isUserError: Bool {
        switch self {
        case .noInternetConnection, .unexpectedError, .serverNotAvailable, .error, .unknownError:
            true
        case .encodableMapping, .parameterEncoding:
            false
        }
    }
}
