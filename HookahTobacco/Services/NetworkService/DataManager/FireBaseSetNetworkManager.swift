//
//  FireBaseSettingNetworkManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation
import FirebaseFirestore

class FireBaseSetNetworkManager: SetDataBaseNetworkingProtocol {
    private var db = Firestore.firestore()
    private var handlerErrors: NetworkHandlerErrors
    
    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }
    
    func addManufacturer(_ manufacturer: Manufacturer, completion: setDBNetworingCompletion?) {
        let data = manufacturer.formatterToDataFireStore()
        db.collection(NamedFireStore.Collections.manufacturers).addDocument(data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(self.handlerErrors.handlerError(error)) }
            else { completion?(nil)}
        }
    }
    
    func setManufacturer(_ newManufacturer: Manufacturer, completion: setDBNetworingCompletion?) {
        if let uid = newManufacturer.uid {
            db.collection(NamedFireStore.Collections.manufacturers)
                .document(uid)
                .setData(newManufacturer.formatterToDataFireStore(),
                         merge: true) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error { completion?(self.handlerErrors.handlerError(error)) }
                    else { completion?(nil)}
                }
        }
    }
    
    func addTobacco(_ tobacco: Tobacco, completion: ((Result<String, NetworkError>) -> Void)?) {
        let data = tobacco.formatterToDataFireStore()
        let docRef = db.collection(NamedFireStore.Collections.tobaccos).document()
        let uidDoc = docRef.documentID
        docRef.setData(data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error))) }
            else { completion?(.success(uidDoc))}
        }
    }
    
    func setTobacco(_ newTobacco: Tobacco, completion: setDBNetworingCompletion?) {
        if let uid = newTobacco.uid {
            db.collection(NamedFireStore.Collections.tobaccos)
                .document(uid)
                .setData(newTobacco.formatterToDataFireStore(),
                         merge: true) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error { completion?(self.handlerErrors.handlerError(error)) }
                    else { completion?(nil)}
                }
        }
        
    }
}

fileprivate extension Manufacturer {
    func formatterToDataFireStore() -> [String: Any] {
        return [
            NamedFireStore.Documents.Manufacturer.name : self.name,
            NamedFireStore.Documents.Manufacturer.country : self.country,
            NamedFireStore.Documents.Manufacturer.description: self.description,
            NamedFireStore.Documents.Manufacturer.image: self.nameImage
        ]
    }
}

fileprivate extension Tobacco {
    func formatterToDataFireStore() -> [String:Any] {
        return [
            NamedFireStore.Documents.Tobacco.name : self.name,
            NamedFireStore.Documents.Tobacco.idManufacturer : self.idManufacturer,
            NamedFireStore.Documents.Tobacco.nameManufacturer : self.nameManufacturer,
            NamedFireStore.Documents.Tobacco.taste : self.taste,
            NamedFireStore.Documents.Tobacco.description : self.description
        ]
    }
}
