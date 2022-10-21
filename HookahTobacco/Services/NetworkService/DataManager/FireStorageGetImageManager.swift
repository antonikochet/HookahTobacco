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
    
    func getImage(for type: NamedFireStorage,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        let storageRef = storage.reference()
        let path = type.path
        let imageRef = storageRef.child(path)
        imageRef.getData(maxSize: 2 * 1024 * 1024, completion: completion)
    }
}
