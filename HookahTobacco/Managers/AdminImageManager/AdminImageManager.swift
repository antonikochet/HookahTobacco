//
//  AdminImageManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation

class AdminImageManager: ImageManager {
    // MARK: - Dependency Network
    private let setImageNetworingService: SetImageNetworkingServiceProtocol

    // MARK: - Initializers
    init(setImageNetworingService: SetImageNetworkingServiceProtocol,
         getImageNetworingService: GetImageNetworkingServiceProtocol,
         imageService: ImageStorageServiceProtocol) {
        self.setImageNetworingService = setImageNetworingService
        super.init(getImageNetworingService: getImageNetworingService,
                   imageService: imageService)
    }
}

extension AdminImageManager: AdminImageManagerProtocol {
    func addImage(by fileURL: URL,
                  for image: NamedImageManager,
                  completion: AdminImageManagerCompletion?
    ) {
        let named = convertNamedImageInNamedImageNetwork(from: image)
        setImageNetworingService.addImage(by: fileURL, for: named) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion?(error)
            } else {
                do {
                    let named = self.convertNamedImageInImageService(from: image)
                    let data = try Data(contentsOf: fileURL)
                    _ = try self.imageService.saveImage(data, for: named)
                    completion?(nil)
                } catch {
                    completion?(ImageStorageError.failedSaveImage)
                }
            }
        }
    }

    func setImage(from oldImage: NamedImageManager,
                  to newURL: URL,
                  for newImage: NamedImageManager,
                  completion: AdminImageManagerCompletion?
    ) {
        let oldNamed = convertNamedImageInNamedImageNetwork(from: oldImage)
        let newNamed = convertNamedImageInNamedImageNetwork(from: newImage)
        setImageNetworingService.setImage(from: oldNamed, to: newURL, for: newNamed) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion?(error)
            } else {
                do {
                    let oldNamed = self.convertNamedImageInImageService(from: oldImage)
                    let newNamed = self.convertNamedImageInImageService(from: newImage)
                    let image = try Data(contentsOf: newURL)
                    _ = try self.imageService.deleteImage(for: oldNamed)
                    _ = try self.imageService.saveImage(image, for: newNamed)
                    completion?(nil)
                } catch {
                    completion?(ImageStorageError.failedSaveImage)
                }
            }
        }
    }

    func setImageName(from oldImage: NamedImageManager,
                      to newImage: NamedImageManager,
                      completion: AdminImageManagerCompletion?
    ) {
        let oldNamed = convertNamedImageInNamedImageNetwork(from: oldImage)
        let newNamed = convertNamedImageInNamedImageNetwork(from: newImage)
        setImageNetworingService.setImageName(from: oldNamed, to: newNamed) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion?(error)
            } else {
                do {
                    let oldNamed = self.convertNamedImageInImageService(from: oldImage)
                    let newNamed = self.convertNamedImageInImageService(from: newImage)
                    let image = try self.imageService.receiveImage(for: oldNamed)
                    _ = try self.imageService.deleteImage(for: oldNamed)
                    _ = try self.imageService.saveImage(image, for: newNamed)
                    completion?(nil)
                } catch {
                    completion?(ImageStorageError.failedSaveImage)
                }
            }
        }
    }
}
