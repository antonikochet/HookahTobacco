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
    
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let imageRef = storage.reference(forURL: url)
        imageRef.getData(maxSize: 2 * 1024 * 1024, completion: completion)
    }
}
