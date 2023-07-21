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
    func handlerError(_ error: Error) -> NetworkError {
        if let apiError = handlerMoyaError(error) {
            return apiError
        } else if let afError = handlerAFError(error) {
            return afError
        } else {
            return .unknownError(error)
        }
    }

    private func handlerMoyaError(_ error: Error) -> NetworkError? {
        guard let moyaError = error as? MoyaError else { return nil }
        switch moyaError {
        case .encodableMapping(let error):
            return .unknownError(error)
        case .requestMapping(let string):
            return .unknownDataError(string)
        case .parameterEncoding(let error):
            return .unknownError(error)
        case .statusCode(let response):
            return handlerStatusCodeError(response.statusCode, response: response)
        case .underlying(let error, _):
            return handlerAFError(error)
        default:
            return nil
        }
    }

    private func handlerStatusCodeError(_ statusCode: Int, response: Response?) -> NetworkError? {
        switch statusCode {
        case 401:
            return .permissionDenied
        case 404:
            return .dataNotFound("")
        default:
            if let apiError = try? response?.map(ApiError.self) {
                return .apiError(apiError)
            }
            return .unexpectedError
        }
    }

    private func handlerAFError(_ error: Error) -> NetworkError? {
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
