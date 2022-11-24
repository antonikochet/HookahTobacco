//
//  ImageServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

protocol ImageServiceProtocol {
    func receiveImage(for item: ImageServiceDataProtocol) throws -> Data
    func saveImage(_ image: Data, for item: ImageServiceDataProtocol) throws -> Bool
}
