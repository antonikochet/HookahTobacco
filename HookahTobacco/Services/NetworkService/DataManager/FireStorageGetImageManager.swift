//
//  FireStorageGetImageManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation
import FirebaseStorage

class FireStorageGetImageManager: GetImageDataBaseProtocol {
    private let storage = Storage.storage()
    private var handlerErrors: NetworkHandlerErrors
    
    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }
    
    func getImage(for type: NamedFireStorage,
                  completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let storageRef = storage.reference()
        let path = type.path
        let imageRef = storageRef.child(path)
        imageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let image):
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(self.handlerErrors.handlerError(error)))
            }
        }
    }
}
