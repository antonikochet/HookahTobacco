//
//  FireBaseSetNetworkingService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation
import FirebaseFirestore

class FireBaseSetNetworkingService {
    private var db = Firestore.firestore()
    private var handlerErrors: NetworkHandlerErrors

    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }

    private func definePathCollection(type: DataNetworkingServiceProtocol) -> String? {
        switch type.self {
        case is Manufacturer: return NamedFireStore.Collections.manufacturers
        case is Tobacco:      return NamedFireStore.Collections.tobaccos
        case is Taste:        return NamedFireStore.Collections.tastes
        case is TobaccoLine:  return NamedFireStore.Collections.tobaccoLines
        default:              return nil
        }
    }
}

extension FireBaseSetNetworkingService: SetDataNetworkingServiceProtocol {
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: AddDataNetworkingCompletion?) {
        guard let pathCollection = definePathCollection(type: data.self) else { return }
        let docRef = db.collection(pathCollection).document()
        let uidDoc = docRef.documentID
        docRef.setData(data.formatterToData()) { [weak self] error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else { completion?(.success(uidDoc)) }
        }
    }

    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: SetDataNetworingCompletion?) {
        guard let pathCollection = definePathCollection(type: data.self) else { return }
        if !data.uid.isEmpty {
            db.collection(pathCollection)
                .document(data.uid)
                .setData(data.formatterToData(),
                         merge: true) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error { completion?(self.handlerErrors.handlerError(error))
                    } else { completion?(nil)}
                }
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
