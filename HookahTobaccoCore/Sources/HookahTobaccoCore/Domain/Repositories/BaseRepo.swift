//
//  BaseRepo.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation
import Moya
import Alamofire

public class BaseRepo {
    private let provider: MoyaProvider<MultiTarget>
    private let authSettings: AuthSettingsProtocol
    private let handlerErrors: NetworkHandlerErrors

    public init(
        provider: MoyaProvider<MultiTarget>,
        authSettings: AuthSettingsProtocol,
        handlerErrors: NetworkHandlerErrors
    ) {
        self.provider = provider
        self.authSettings = authSettings
        self.handlerErrors = handlerErrors
    }

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }

    private func handlerError(_ error: Error, completion: BlockWithParam<DomainError>) {
        self.showError("\(error)")
        let domainError = handlerErrors.handlerError(error)
        // TODO: - добавить протокол который будет отправлять в метрику данные об не юзер ошибке
        completion(domainError)
    }

    func sendRequest<T: Decodable>(
        object: T.Type,
        target: TargetType,
        completion: BlockWithParam<T>?,
        failure: BlockWithParam<DomainError>?
    ) {
        provider.request(object: object, target: MultiTarget(target)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(response)
            case let .failure(error):
                self.handlerError(error) { error in
                    failure?(error)
                }
            }
        }
    }

    func sendRequest<T: Decodable>(
        object: T.Type,
        target: TargetType,
        completion: ResultBlock<T>?
    ) {
        provider.request(object: object, target: MultiTarget(target)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(.success(response))
            case let .failure(error):
                self.handlerError(error) { error in
                    completion?(.failure(error))
                }
            }
        }
    }

    // TODO: - подумать нужен ли он тут именно?
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
