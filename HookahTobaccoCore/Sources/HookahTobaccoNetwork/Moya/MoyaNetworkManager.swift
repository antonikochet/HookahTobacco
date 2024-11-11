//
//  MoyaNetworkManager.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Foundation
import Moya

public final class MoyaNetworkManager: NetworkManagerProtocol {
    
    private let networkProvider: MultiMoyaProvider
    
    public init(networkProvider: MultiMoyaProvider) {
        self.networkProvider = networkProvider
    }
    
    public func request<T: Decodable, Target: DefaultTarget>(
        object: T.Type,
        target: Target,
        completion: @escaping NetworkCompletion<T>
    ) {
        networkProvider.request(MultiTarget(target), callbackQueue: .main) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(T.self, using: JSONDecoder.defaultDecoder, failsOnEmptyData: false)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func request<T: Decodable, Target: DefaultTarget>(
        object: T.Type,
        target: Target
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            networkProvider.request(MultiTarget(target), callbackQueue: .main) { result in
                switch result {
                case let .success(response):
                    do {
                        let data = try response.map(T.self, using: JSONDecoder.defaultDecoder, failsOnEmptyData: false)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
