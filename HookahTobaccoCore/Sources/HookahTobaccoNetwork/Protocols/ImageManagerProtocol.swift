//
//  ImageManagerProtocol.swift
//
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation

public protocol ImageManagerProtocol {
    func fetchImage(_ url: URL, completion: @escaping NetworkCompletion<Data?>)
    func fetchImage(_ url: URL) async throws -> Data?
}
