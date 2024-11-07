//
//  ApiHandlerErrors.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation
import Moya
import Alamofire

public struct ApiHandlerErrors: NetworkHandlerErrors {
    public init() {
        
    }
    
    public func handlerError(_ error: Error) -> ApiErrorType {
        if let apiError = handlerMoyaError(error) {
            return apiError
        } else if let afError = handlerAFError(error) {
            return afError
        } else {
            return .unknownError(error)
        }
    }

    private func handlerMoyaError(_ error: Error) -> ApiErrorType? {
        guard let moyaError = error as? MoyaError else { return nil }
        switch moyaError {
        case .encodableMapping(let error):
            return .encodableMapping(error)
        case .requestMapping:
            return .unexpectedError
        case .parameterEncoding(let error):
            return .parameterEncoding(error)
        case .statusCode(let response):
            return handlerApiError(response: response)
        case .underlying(let error, _):
            return handlerAFError(error)
        default:
            return nil
        }
    }

    private func handlerApiError(response: Response) -> ApiErrorType? {
        if let apiErrorDTO = try? response.map(ApiErrorsDTO.self) {
            return .apiError(apiErrorDTO.errors)
        }
        return .unexpectedError
    }

    private func handlerAFError(_ error: Error) -> ApiErrorType? {
        guard let afError = error.asAFError else { return nil }
        switch afError {
        case let .sessionTaskFailed(error):
            if error._code == NSURLErrorTimedOut ||
                error._code == NSURLErrorNotConnectedToInternet {
                return .noInternetConnection
            } else if error._code == NSURLErrorCannotConnectToHost {
                return .serverNotAvailable
            }
            return .unknownError(error)
        default:
            return .unknownError(error)
        }
    }
}
