//
//  ImageStorageError.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

enum ImageStorageError: Error {
    case imageNotFound
    case directoryNotFound
    case imagesDirectoryNotFound
    case failedCreateDirectory(directory: String)
    case failedSaveImage
    case failedDeleteImage(item: ImageStorageServiceDataProtocol)
}
