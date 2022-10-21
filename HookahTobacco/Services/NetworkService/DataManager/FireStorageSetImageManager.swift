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
    
    func setImage(_ image: Data, for type: NamedFireStorage, completion: @escaping Completion) {
        //TODO: реализовать функцию
        fatalError("not implemented func setImage(_: Data,...)")
    }
    
    func setImage(_ urlFile: URL, for type: NamedFireStorage, completion: @escaping Completion) {
        let path = type.path
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        imageRef.putFile(from: urlFile) { _, error in
            completion(error)
        }
    }
}
