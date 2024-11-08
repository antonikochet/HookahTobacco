//
//  BaseApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import Moya
import Alamofire
import UIKit
import HookahTobaccoCore
import HookahTobaccoNetwork

class BaseApiService {
    private let provider: MultiMoyaProvider
    private let authSettings: AuthSettingsProtocol
    private let handlerErrors: NetworkHandlerErrors

    init(provider: MultiMoyaProvider,
         authSettings: AuthSettingsProtocol,
         handlerErrors: NetworkHandlerErrors) {
        self.provider = provider
        self.authSettings = authSettings
        self.handlerErrors = handlerErrors
    }

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }

    private func handlerError(_ error: Error, completion: BlockWithParam<HTError>) {
        self.showError("\(error)")
        let htError = handlerErrors.handlerError(error)
        if case let .apiError(errors) = htError,
           let apiError = errors.first,
           apiError.code == "authentication_failed" {
            authSettings.setToken(nil)
            let router = (UIApplication.shared.delegate as? AppDelegate)?.router
            router?.presentAlert(type: .error(message: apiError.message), completion: {
                router?.restartViewApp()
            })
            return
        }
        completion(htError)
    }

    func receiveImage(_ url: String, completion: ResultBlock<Data?>?) {
        AF.request(url).response { [weak self] response in
            guard let self else { return }
            switch response.result {
            case let .success(data):
                completion?(.success(data))
            case let .failure(error):
                self.handlerError(error) { error in
                    completion?(.failure(error))
                }
            }
        }
    }
}
