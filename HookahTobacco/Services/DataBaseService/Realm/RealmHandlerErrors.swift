//
//  RealmHandlerErrors.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation
import RealmSwift

struct RealmHandlerErrors: DataBaseHandlerErrorsProtocol {
    func handlerError(_ error: Error) -> DataBaseError {
        guard let realmError = error as? Realm.Error else { return .failError(error) }
        switch realmError.code {
        case .fileNotFound: return .fileDBNotFound
        case .schemaMismatch: return .schemaMismatchError
        case .fileAccess: return .fileAccessError
        default: return .failError(error)
        }
    }
}
