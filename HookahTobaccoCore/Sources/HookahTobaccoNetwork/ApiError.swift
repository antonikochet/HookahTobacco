//
//  ApiError.swift
//  
//
//  Created by Антон Кочетков on 07.11.2024.
//

public enum ApiErrorType {
    case noInternetConnection
    case unexpectedError
    case serverNotAvailable
    case encodableMapping(Error)
    case parameterEncoding(Error)
    case apiError([ApiErrorDTO])
    case unknownError(Error)
}
