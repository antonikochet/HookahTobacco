//
//  BaseRepo.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation
import Moya
import Alamofire
import HookahTobaccoNetwork

open class BaseRepo {
    private let networkManager: NetworkManagerProtocol
    private let authSettings: AuthSettingsProtocol
    private let handlerErrors: NetworkHandlerErrors
    private let sendingErrorInMetric: SendingMetricErrorProtocol

    public init(
        networkManager: NetworkManagerProtocol,
        authSettings: AuthSettingsProtocol,
        handlerErrors: NetworkHandlerErrors,
        sendingErrorInMetric: SendingMetricErrorProtocol
    ) {
        self.networkManager = networkManager
        self.authSettings = authSettings
        self.handlerErrors = handlerErrors
        self.sendingErrorInMetric = sendingErrorInMetric
    }

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }

    private func handlerError(_ error: Error, completion: BlockWithParam<DomainError>) {
        self.showError("\(error)")
        let apiError = handlerErrors.handlerError(error)
        let domainError = DomainError(apiError: apiError)
        switch apiError {
        case .parameterEncoding(let error), .encodableMapping(let error):
            sendingErrorInMetric.send(error)
        default:
            break
        }
        completion(domainError)
    }
    
    private func handlerError(_ error: Error) -> DomainError {
        self.showError("\(error)")
        let apiError = handlerErrors.handlerError(error)
        let domainError = DomainError(apiError: apiError)
        switch apiError {
        case .parameterEncoding(let error), .encodableMapping(let error):
            sendingErrorInMetric.send(error)
        default:
            break
        }
        return domainError
    }

    public func sendRequest<T: Decodable>(
        object: T.Type,
        target: DefaultTarget,
        completion: BlockWithParam<T>?,
        failure: BlockWithParam<DomainError>?
    ) {
        networkManager.request(object: object, target: target) { [weak self] result in
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

    public func sendRequest<T: Decodable>(
        object: T.Type,
        target: DefaultTarget,
        completion: ResultBlock<T>?
    ) {
        networkManager.request(object: object, target: target) { [weak self] result in
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
    
    public func sendRequest<T: Decodable, Target: DefaultTarget>(
        object: T.Type,
        target: Target
    ) async throws -> T {
        do {
            return try await networkManager.request(object: object, target: target)
        } catch {
            throw handlerError(error)
        }
    }

    // TODO: - подумать нужен ли он тут именно?
    public func receiveImage(_ url: String, completion: ResultBlock<Data?>?) {
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
    
    // TODO: - подумать нужен ли он тут именно?
    public func receiveImage(_ url: String) async throws -> Data? {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).response { [weak self] response in
                guard let self else { return }
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handlerError(error))
                }
            }
        }
    }
}
