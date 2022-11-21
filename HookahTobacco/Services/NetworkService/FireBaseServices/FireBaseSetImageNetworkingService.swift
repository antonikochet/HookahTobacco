//
//  FireBaseSetImageNetworkingService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.10.2022.
//

import Foundation
import FirebaseStorage

class FireBaseSetImageNetworkingService: SetImageNetworkingServiceProtocol {
    private let storage = Storage.storage()
    private var handlerErrors: NetworkHandlerErrors
    
    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }
    
    func addImage(by fileURL: URL, for image: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        let path = image.path
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        imageRef.putFile(from: fileURL) { [weak self] _, error in
            guard let self = self else { return }
            completion(error != nil ? self.handlerErrors.handlerError(error!) : nil)
        }
    }
    
//    func setImage(_ image: Data, for type: NamedFireStorage, completion: @escaping Completion) {
//        //TODO: реализовать функцию
//        fatalError("not implemented func setImage(_: Data,...)")
//    }
    
    func setImage(_ urlFile: URL, for type: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        let path = type.path
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        imageRef.putFile(from: urlFile) { [weak self] _, error in
            guard let self = self else { return }
            completion(error != nil ? self.handlerErrors.handlerError(error!) : nil)
        }
    }
    
    func setImage(from oldImage: ImageNetworkingDataProtocol, to newURL: URL, for newImage: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        var deleteError: NetworkError? = nil
        let oldPath = oldImage.path
        let oldRef = storage.reference(withPath: oldPath)
        let newPath = newImage.path
        let newRef = storage.reference(withPath: newPath)
        oldRef.delete { [weak self] error in
            guard let self = self else { return }
            if error != nil { deleteError = self.handlerErrors.handlerError(error!) }
        }
        
        newRef.putFile(from: newURL) { [weak self] _, error in
            guard let self = self else { return }
            if error != nil { completion(self.handlerErrors.handlerError(error!)) }
            else { completion(deleteError) }
        }
    }
    
    func setImageName(from oldImage: ImageNetworkingDataProtocol, to newImage: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        let oldPath = oldImage.path
        let oldRef = storage.reference(withPath: oldPath)
        
        let newPath = newImage.path
        let newRef = storage.reference(withPath: newPath)
        //TODO: переписать метод для избавления вложенности
        oldRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    newRef.putData(data) { result in
                        switch result {
                            case .success(_):
                                oldRef.delete { error in
                                    completion(error != nil ? self.handlerErrors.handlerError(error!) : nil)
                                }
                            case .failure(let error):
                                completion(self.handlerErrors.handlerError(error))
                        }
                    }
                case .failure(let error):
                    completion(self.handlerErrors.handlerError(error))
            }
        }
    }
}
