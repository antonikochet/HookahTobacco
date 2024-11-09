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
