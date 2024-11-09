//
//  ImageManager.swift
//
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation
import Alamofire

public final class ImageManager: ImageManagerProtocol {
    public init() {
        
    }
    
    public func fetchImage(_ url: URL, completion: @escaping NetworkCompletion<Data?>) {
        AF.request(url).response { result in
            switch result.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchImage(_ url: URL) async throws -> Data? {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).response { result in
                switch result.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
