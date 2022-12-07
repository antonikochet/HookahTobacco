//
//  ImageManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 06.12.2022.
//

import Foundation

class ImageManager {
    // MARK: - Public properties
    let imageWorkingQueue = DispatchQueue(label: "ru.HookahTobacco.DataManager.getImage")

    // MARK: - Dependency Network
    private let getImageNetworingService: GetImageNetworkingServiceProtocol

    // MARK: - Dependency Image
    let imageService: ImageServiceProtocol

    // MARK: - Initializers
    init(getImageNetworingService: GetImageNetworkingServiceProtocol,
         imageService: ImageServiceProtocol) {
        self.getImageNetworingService = getImageNetworingService
        self.imageService = imageService
    }

    // MARK: - Public methods
    func convertNamedImageInNamedImageNetwork(from type: NamedImageManager) -> NamedFireStorage {
        var named: NamedFireStorage
        switch type {
        case .manufacturerImage(let nameImage):
            named = NamedFireStorage.manufacturerImage(name: nameImage)
        case .tobaccoImage(let manufacturer, let uid, let type):
            named = NamedFireStorage.tobaccoImage(manufacturer: manufacturer, uid: uid, type: type)
        }
        return named
    }

    func convertNamedImageInImageService(from type: NamedImageManager) -> NamedImage {
        var named: NamedImage
        switch type {
        case .manufacturerImage(let nameImage):
            named = NamedImage.manufacturer(nameImage: nameImage)
        case .tobaccoImage(let manufacturer, let uid, let type):
            named = NamedImage.tobacco(manufacturer: manufacturer, uid: uid, type: type)
        }
        return named
    }

    // MARK: - Private methods
    private func receiveImageFromNetwork(for type: NamedImageManager,
                                         completion: @escaping (Result<Data, Error>) -> Void) {
        let named = convertNamedImageInNamedImageNetwork(from: type)
        getImageNetworingService.getImage(for: named) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                let named = self.convertNamedImageInImageService(from: type)
                do {
                    _ = try self.imageService.saveImage(image, for: named)
                } catch {
                    print(error)
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - ImageManagerProtocol implementation
extension ImageManager: ImageManagerProtocol {
    func getImage(for type: NamedImageManager, completion: @escaping (Result<Data, Error>) -> Void) {
        imageWorkingQueue.async {
            do {
                let named = self.convertNamedImageInImageService(from: type)
                completion(.success(try self.imageService.receiveImage(for: named)))
            } catch {
                self.receiveImageFromNetwork(for: type, completion: completion)
            }
        }
    }
}
