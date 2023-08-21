//
//  BaseApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import Moya
import Alamofire

class BaseApiService {
    private let provider: MoyaProvider<MultiTarget>
    private let handlerErrors: NetworkHandlerErrors

    init(provider: MoyaProvider<MultiTarget>,
         handlerErrors: NetworkHandlerErrors) {
        self.provider = provider
        self.handlerErrors = handlerErrors
    }

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }

    func sendRequest<T: Decodable>(
        object: T.Type,
        target: TargetType,
        completion: CompletionBlockWithParam<T>?,
        failure: CompletionBlockWithParam<HTError>?
    ) {
        provider.request(object: object, target: MultiTarget(target)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(response)
            case let .failure(error):
                self.showError("\(error)")
                failure?(self.handlerErrors.handlerError(error))
            }
        }
    }

    func sendRequest<T: Decodable>(
        object: T.Type,
        target: TargetType,
        completion: CompletionResultBlock<T>?
    ) {
        provider.request(object: object, target: MultiTarget(target)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(.success(response))
            case let .failure(error):
                self.showError("\(error)")
                completion?(.failure(self.handlerErrors.handlerError(error)))
            }
        }
    }

    func receiveImage(_ url: String, completion: CompletionResultBlock<Data?>?) {
        AF.request(url).response { [weak self] response in
            guard let self else { return }
            switch response.result {
            case let .success(data):
                completion?(.success(data))
            case let .failure(error):
                self.showError("\(error)")
                completion?(.failure(self.handlerErrors.handlerError(error)))
            }
        }
    }
}
