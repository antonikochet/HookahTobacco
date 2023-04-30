//
//  ApiHandlerErrors.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 30.04.2023.
//

import Foundation

struct ApiHandlerErrors: NetworkHandlerErrors {
    func handlerError(_ error: Error) -> NetworkError {
        if let apiError = handlerApiError(error) {
            return apiError
        } else if let afError = handlerAFError(error) {
            return afError
        } else {
            return .unknownError(error)
        }
    }

    private func handlerApiError(_ error: Error) -> NetworkError? {
        guard let apiError = error as? ApiError else { return nil }
        // TODO: - расписать ошибки кастомные
        return nil
    }

    private func handlerAFError(_ error: Error) -> NetworkError? {
        guard let afError = error.asAFError else { return nil }
        // TODO: - расписать ошибки AFError
        return nil
    }
}
