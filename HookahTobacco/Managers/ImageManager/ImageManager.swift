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
    let imageService: ImageStorageServiceProtocol

    // MARK: - Initializers
    init(getImageNetworingService: GetImageNetworkingServiceProtocol,
         imageService: ImageStorageServiceProtocol) {
        self.getImageNetworingService = getImageNetworingService
        self.imageService = imageService
    }

    // MARK: - Public methods
    func convertNamedImageInImageService(from url: String) -> NamedImageStorage? {
        var named: NamedImageStorage?
        if let url = URL(string: url) {
            let pathComponents = url.pathComponents
            if pathComponents.contains(where: { $0 == "tobaccos" }) {
                if let manufacturer = pathComponents.dropLast().last,
                   let nameFile = pathComponents.last {
                    named = NamedImageStorage.tobacco(manufacturer: manufacturer, name: nameFile)
                }
            } else {
                if let nameFile = pathComponents.last {
                    named = NamedImageStorage.manufacturer(nameImage: nameFile)
                }
            }
        }
        return named
    }

    // MARK: - Private methods
    private func receiveImageFromNetwork(for url: String,
                                         completion: @escaping (Result<Data, HTError>) -> Void) {
        getImageNetworingService.getImage(for: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                if let named = self.convertNamedImageInImageService(from: url) {
                    // TODO: - вернуть обратно сохранение изображений
//                    do {
//                        _ = try self.imageService.saveImage(image, for: named)
//                    } catch {
//                        print(error)
//                    }
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
    func getImage(for url: String, completion: @escaping (Result<Data, HTError>) -> Void) {
        imageWorkingQueue.async {
            do {
                if let named = self.convertNamedImageInImageService(from: url) {
                    completion(.success(try self.imageService.receiveImage(for: named)))
                } else {
                    self.receiveImageFromNetwork(for: url, completion: completion)
                }
            } catch {
                self.receiveImageFromNetwork(for: url, completion: completion)
            }
        }
    }
}
