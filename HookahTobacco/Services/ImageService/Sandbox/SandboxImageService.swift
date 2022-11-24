//
//  SandboxImageService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

final class SandboxImageService {
    // MARK: - Private properties
    private let nameImageDirectory = "Images"

    private let fileManager: FileManager = FileManager.default

    private var documentsDirectory: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private var isExtestsImagesDirectory: Bool {
        guard let documentsDirectory = documentsDirectory else { return false }
        return fileManager.fileExists(
            atPath: documentsDirectory
                .appendingPathComponent(nameImageDirectory)
                .path
        )
    }

    private func createImagesDirectory() -> Bool {
        do {
            guard let urlDirectory = documentsDirectory?
                .appendingPathComponent(nameImageDirectory)
            else { return false }
            try fileManager.createDirectory(at: urlDirectory,
                                            withIntermediateDirectories: false)
            return true
        } catch {
            print(error)
            return false
        }
    }
    private func isExtests(url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }
}

// MARK: - ImageServiceProtocol implementation
extension SandboxImageService: ImageServiceProtocol {
    func receiveImage(for item: ImageServiceDataProtocol) throws -> Data {
        guard let documentsDirectory = documentsDirectory else { throw ImageError.directoryNotFound }
        if !isExtestsImagesDirectory,
           !createImagesDirectory() {
            throw ImageError.imagesDirectoryNotFound
        }
        let urlItem = documentsDirectory.appendingPathComponent(nameImageDirectory)
                                        .appendingPathComponent(item.directories)
                                        .appendingPathComponent(item.nameFile)
        if !isExtests(url: urlItem) {
            throw ImageError.imageNotFound
        }

        if let image = fileManager.contents(atPath: urlItem.path) {
            return image
        } else {
            throw ImageError.imageNotFound
        }
    }

    func saveImage(_ image: Data, for item: ImageServiceDataProtocol) throws -> Bool {
        guard let documentsDirectory = documentsDirectory else { return false }
        if !isExtestsImagesDirectory,
           !createImagesDirectory() {
            throw ImageError.imagesDirectoryNotFound
        }

        let urlDirectory = documentsDirectory
            .appendingPathComponent(nameImageDirectory)
            .appendingPathComponent(item.directories)
        if !isExtests(url: urlDirectory) {
            do {
                try fileManager.createDirectory(at: urlDirectory,
                                                withIntermediateDirectories: true)
            } catch {
                throw ImageError.failedCreateDirectory(directory: item.directories)
            }
        }

        let urlFile = urlDirectory.appendingPathComponent(item.nameFile)
        return fileManager.createFile(atPath: urlFile.path, contents: image)
    }
}
