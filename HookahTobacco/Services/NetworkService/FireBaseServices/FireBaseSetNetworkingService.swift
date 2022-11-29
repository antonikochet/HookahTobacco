//
//  FireBaseSetNetworkingService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation
import FirebaseFirestore

class FireBaseSetNetworkingService: SetDataNetworkingServiceProtocol {
    private var db = Firestore.firestore()
    private var handlerErrors: NetworkHandlerErrors

    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }

    func addManufacturer(_ manufacturer: Manufacturer, completion: SetDataNetworingCompletion?) {
        let data = manufacturer.formatterToDataFireStore()
        db.collection(NamedFireStore.Collections.manufacturers).addDocument(data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(self.handlerErrors.handlerError(error))
            } else { completion?(nil)}
        }
    }

    func setManufacturer(_ newManufacturer: Manufacturer, completion: SetDataNetworingCompletion?) {
        if let uid = newManufacturer.uid {
            db.collection(NamedFireStore.Collections.manufacturers)
                .document(uid)
                .setData(newManufacturer.formatterToDataFireStore(),
                         merge: true) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error { completion?(self.handlerErrors.handlerError(error))
                    } else { completion?(nil)}
                }
        }
    }

    func addTobacco(_ tobacco: Tobacco, completion: ((Result<String, NetworkError>) -> Void)?) {
        let data = tobacco.formatterToDataFireStore()
        let docRef = db.collection(NamedFireStore.Collections.tobaccos).document()
        let uidDoc = docRef.documentID
        docRef.setData(data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else { completion?(.success(uidDoc))}
        }
    }

    func setTobacco(_ newTobacco: Tobacco, completion: SetDataNetworingCompletion?) {
        db.collection(NamedFireStore.Collections.tobaccos)
            .document(newTobacco.uid)
            .setData(newTobacco.formatterToDataFireStore(),
                     merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error { completion?(self.handlerErrors.handlerError(error))
                } else { completion?(nil)}
            }
    }

    func addTaste(_ taste: Taste, completion: ((Result<String, NetworkError>) -> Void)?) {
        let data = taste.formatterToDataFireStore()
        let docRef = db.collection(NamedFireStore.Collections.tastes).document()
        let uidDoc = docRef.documentID
        docRef.setData(data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else { completion?(.success(uidDoc)) }
        }
    }

    func setTaste(_ taste: Taste, completion: SetDataNetworingCompletion?) {
        let data = taste.formatterToDataFireStore()
        let uid = taste.uid
        db.collection(NamedFireStore.Collections.tastes)
            .document(uid)
            .setData(data,
                     merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error { completion?(self.handlerErrors.handlerError(error))
                } else { completion?(nil) }
            }
    }

    func setDBVersion(_ newVersion: Int, completion: SetDataNetworingCompletion?) {
        let data: [String: Any] = [NamedFireStore.Documents.System.versionDB: newVersion]
        db.collection(NamedFireStore.Collections.system)
            .document("debug")
            .setData(data,
                     merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error { completion?(self.handlerErrors.handlerError(error))
                } else { completion?(nil) }
            }
    }
}

fileprivate extension Manufacturer {
    func formatterToDataFireStore() -> [String: Any] {
        return [
            NamedFireStore.Documents.Manufacturer.name: self.name,
            NamedFireStore.Documents.Manufacturer.country: self.country,
            NamedFireStore.Documents.Manufacturer.description: self.description,
            NamedFireStore.Documents.Manufacturer.image: self.nameImage,
            NamedFireStore.Documents.Manufacturer.link: self.link ?? ""
        ]
    }
}

fileprivate extension Tobacco {
    func formatterToDataFireStore() -> [String: Any] {
        return [
            NamedFireStore.Documents.Tobacco.name: self.name,
            NamedFireStore.Documents.Tobacco.idManufacturer: self.idManufacturer,
            NamedFireStore.Documents.Tobacco.nameManufacturer: self.nameManufacturer,
            NamedFireStore.Documents.Tobacco.taste: self.tastes.map { $0.uid },
            NamedFireStore.Documents.Tobacco.description: self.description
        ]
    }
}

fileprivate extension Taste {
    func formatterToDataFireStore() -> [String: Any] {
        return [
            NamedFireStore.Documents.Taste.taste: self.taste,
            NamedFireStore.Documents.Taste.type: self.typeTaste
        ]
    }
}
