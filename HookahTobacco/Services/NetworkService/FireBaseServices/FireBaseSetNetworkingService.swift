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
        let data = manufacturer.formatterToData()
        db.collection(NamedFireStore.Collections.manufacturers).addDocument(data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(self.handlerErrors.handlerError(error))
            } else { completion?(nil)}
        }
    }

    func setManufacturer(_ newManufacturer: Manufacturer, completion: SetDataNetworingCompletion?) {
        if !newManufacturer.uid.isEmpty {
            db.collection(NamedFireStore.Collections.manufacturers)
                .document(newManufacturer.uid)
                .setData(newManufacturer.formatterToData(),
                         merge: true) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error { completion?(self.handlerErrors.handlerError(error))
                    } else { completion?(nil)}
                }
        }
    }

    func addTobacco(_ tobacco: Tobacco, completion: ((Result<String, NetworkError>) -> Void)?) {
        let data = tobacco.formatterToData()
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
            .setData(newTobacco.formatterToData(),
                     merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error { completion?(self.handlerErrors.handlerError(error))
                } else { completion?(nil)}
            }
    }

    func addTaste(_ taste: Taste, completion: ((Result<String, NetworkError>) -> Void)?) {
        let data = taste.formatterToData()
        let docRef = db.collection(NamedFireStore.Collections.tastes).document()
        let uidDoc = docRef.documentID
        docRef.setData(data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else { completion?(.success(uidDoc)) }
        }
    }

    func setTaste(_ taste: Taste, completion: SetDataNetworingCompletion?) {
        let data = taste.formatterToData()
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

    func addTobaccoLine(_ tobaccoLine: TobaccoLine, completion: AddDataNetworkingCompletion?) {
        let data = tobaccoLine.formatterToData()
        let docRef = db.collection(NamedFireStore.Collections.tobaccoLines).document()
        let uidDoc = docRef.documentID
        docRef.setData(data) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else { completion?(.success(uidDoc)) }
        }
    }

    func setTobaccoLine(_ tobaccoLine: TobaccoLine, completion: SetDataNetworingCompletion?) {
        let data = tobaccoLine.formatterToData()
        let uid = tobaccoLine.uid
        db.collection(NamedFireStore.Collections.tobaccoLines)
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
