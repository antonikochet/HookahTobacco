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
    
    func addManufacturer(_ manufacturer: Manufacturer, completion: setDBNetworingCompletion?) {
        let data = manufacturer.formatterToDataFireStore()
        db.collection(NamedFireStore.Collections.manufacturers).addDocument(data: data, completion: completion)
    }
    
    func setManufacturer(_ newManufacturer: Manufacturer, completion: setDBNetworingCompletion?) {
        if let uid = newManufacturer.uid {
            db.collection(NamedFireStore.Collections.manufacturers)
                .document(uid)
                .setData(newManufacturer.formatterToDataFireStore(),
                         merge: true,
                         completion: completion)
        }
    }
    
    func addTobacco(_ tobacco: Tobacco, completion: setDBNetworingCompletion?) {
        let data = tobacco.formatterToDataFireStore()
        db.collection(NamedFireStore.Collections.tobaccos).addDocument(data: data, completion: completion)
    }
    
    func setTobacco(_ newTobacco: Tobacco, completion: setDBNetworingCompletion?) {
        if let uid = newTobacco.uid {
            db.collection(NamedFireStore.Collections.tobaccos)
                .document(uid)
                .setData(newTobacco.formatterToDataFireStore(),
                         merge: true,
                         completion: completion)
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
            NamedFireStore.Documents.Tobacco.taste : self.taste,
            NamedFireStore.Documents.Tobacco.description : self.description
        ]
    }
}
