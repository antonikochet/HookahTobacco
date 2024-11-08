//
//  ImageManager.swift
//  
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation
import HookahTobaccoNetwork

public protocol ImageManagerProtocol {
    func fetchImage(_ url: URL, completion: @escaping ResultBlock<Data?>)
    func fetchImage(_ url: URL) async throws -> Data?
}

public final class ImageManager: ImageManagerProtocol {
    
    private let imageManager: HookahTobaccoNetwork.ImageManagerProtocol
    private let handlerErrors: NetworkHandlerErrors
    
    public init(
        imageManager: HookahTobaccoNetwork.ImageManagerProtocol,
        handlerErrors: NetworkHandlerErrors
    ) {
        self.imageManager = imageManager
        self.handlerErrors = handlerErrors
    }
    
    private func handlerError(_ error: Error) -> DomainError {
        let apiError = handlerErrors.handlerError(error)
        let domainError = DomainError(apiError: apiError)
        return domainError
    }

    public func fetchImage(_ url: URL, completion: @escaping ResultBlock<Data?>) {
        imageManager.fetchImage(url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                let error = self.handlerError(error)
                completion(.failure(error))
            }
        }
    }
    
    public func fetchImage(_ url: URL) async throws -> Data? {
        do {
            return try await imageManager.fetchImage(url)
        } catch {
            throw handlerError(error)
        }
    }
}
