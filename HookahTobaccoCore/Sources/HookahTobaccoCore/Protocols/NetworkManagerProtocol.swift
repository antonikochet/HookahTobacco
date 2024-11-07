//
//  NetworkManagerProtocol.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Foundation

public typealias NetworkCompletion<T> = (Result<T, Error>) -> Void

public protocol NetworkManagerProtocol {
    func request<T: Decodable, Target: DefaultTarget>(
        object: T.Type,
        target: Target,
        completion: @escaping NetworkCompletion<T>
    )
    
    func request<T: Decodable, Target: DefaultTarget>(
        object: T.Type,
        target: Target
    ) async throws -> T
}
