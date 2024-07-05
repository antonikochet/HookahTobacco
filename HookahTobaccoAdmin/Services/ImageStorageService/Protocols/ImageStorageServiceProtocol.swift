//
//  ImageStorageServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

protocol ImageStorageServiceProtocol {
    func receiveImage(for item: ImageStorageServiceDataProtocol) throws -> Data
    func saveImage(_ image: Data, for item: ImageStorageServiceDataProtocol) throws -> Bool
    func deleteImage(for item: ImageStorageServiceDataProtocol) throws -> Bool
}
