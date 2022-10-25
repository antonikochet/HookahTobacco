//
//  FileStorageSetManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.10.2022.
//

import Foundation
import FirebaseStorage

class FireStorageSetImageManager: SetImageDataBaseProtocol {
    private let storage = Storage.storage()
    func addImage(by fileURL: URL, for image: NamedFireStorage, completion: @escaping Completion) {
        let path = image.path
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        imageRef.putFile(from: fileURL) { _, error in
            completion(error)
        }
    }
    
//    func setImage(_ image: Data, for type: NamedFireStorage, completion: @escaping Completion) {
//        //TODO: реализовать функцию
//        fatalError("not implemented func setImage(_: Data,...)")
//    }
    
    func setImage(_ urlFile: URL, for type: NamedFireStorage, completion: @escaping Completion) {
        let path = type.path
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        imageRef.putFile(from: urlFile) { _, error in
            completion(error)
        }
    }
    
    func setImage(from oldImage: NamedFireStorage, to newURL: URL, for newImage: NamedFireStorage, completion: @escaping Completion) {
        var deleteError: Error? = nil
        let oldPath = oldImage.path
        let oldRef = storage.reference(withPath: oldPath)
        let newPath = newImage.path
        let newRef = storage.reference(withPath: newPath)
        oldRef.delete { error in
            if error != nil { deleteError = error }
        }
        
        newRef.putFile(from: newURL) { _, error in
            if error != nil { completion(error) }
            else { completion(deleteError) }
        }
    }
    func setImageName(from oldImage: NamedFireStorage, to newImage: NamedFireStorage, completion: @escaping Completion) {
        let oldPath = oldImage.path
        let oldRef = storage.reference(withPath: oldPath)
        
        let newPath = newImage.path
        let newRef = storage.reference(withPath: newPath)
        oldRef.getData(maxSize: 2 * 1024 * 1024) { result in
            switch result {
                case .success(let data):
                    newRef.putData(data) { result in
                        switch result {
                            case .success(_):
                                oldRef.delete(completion: completion)
                            case .failure(let error):
                                completion(error)
                        }
                    }
                case .failure(let error):
                    completion(error)
            }
        }
    }
}
