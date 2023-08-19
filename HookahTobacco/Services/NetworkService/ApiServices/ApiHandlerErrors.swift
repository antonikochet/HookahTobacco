//
//  ApiHandlerErrors.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.04.2023.
//

import Foundation
import Moya
import Alamofire

struct ApiHandlerErrors: NetworkHandlerErrors {
    func handlerError(_ error: Error) -> HTError {
        if let apiError = handlerMoyaError(error) {
            return apiError
        } else if let afError = handlerAFError(error) {
            return afError
        } else {
            return .unknownError(error)
        }
    }

    private func handlerMoyaError(_ error: Error) -> HTError? {
        guard let moyaError = error as? MoyaError else { return nil }
        switch moyaError {
        case .encodableMapping(let error):
            return .unknownError(error)
        case .requestMapping:
            return .unexpectedError
        case .parameterEncoding(let error):
            return .unknownError(error)
        case .statusCode(let response):
            return handlerApiError(response: response)
        case .underlying(let error, _):
            return handlerAFError(error)
        default:
            return nil
        }
    }

    private func handlerApiError(response: Response) -> HTError? {
        if let apiErrorResponse = try? response.map(ApiErrorResponse.self) {
            return .apiError(apiErrorResponse.errors)
        }
        return .unexpectedError
    }

    private func handlerAFError(_ error: Error) -> HTError? {
        guard let afError = error.asAFError else { return nil }
        switch afError {
        case let .sessionTaskFailed(error):
            if error._code == NSURLErrorTimedOut {
                return .noInternetConnection
            }
            return .unknownError(error)
        default:
            return .unknownError(error)
        }
    }
}
