//
//  FirebaseHandlerErrors.swift
//  HookahTobacco
//
//  Created by антон кочетков on 02.11.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct FireBaseHandlerErrors: NetworkHandlerErrors {
    func handlerError(_ error: Error) -> NetworkError {
        let nsError = error as NSError

        if let storeError = handlerFireStoreError(nsError) { return storeError
        } else if let storageError = handlerStorageError(error) { return storageError
        } else { return .unknownError(nsError) }
    }

    private func handlerFireStoreError(_ nsError: NSError) -> NetworkError? {
        switch nsError.code {
        case FirestoreErrorCode.notFound.rawValue:          return .dataNotFound("") // TODO: ввести обозначение
        case FirestoreErrorCode.permissionDenied.rawValue:  return .permissionDenied

        default:                                            return nil
        }
    }

    private func handlerStorageError(_ error: Error) -> NetworkError? {
        if let storageError = error as? StorageError {
            switch storageError {
            case .objectNotFound(let string):                   return .dataNotFound(string)

            default:                                            return nil
            }
        } else {
            let nsError = error as NSError
            switch nsError.code {
            case StorageErrorCode.unauthorized.rawValue:        return .permissionDenied

            default:                                            return .unknownError(error)
            }
        }
    }
}
