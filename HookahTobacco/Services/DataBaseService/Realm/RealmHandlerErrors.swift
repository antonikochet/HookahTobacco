//
//  RealmHandlerErrors.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation
import RealmSwift

struct RealmHandlerErrors: DataBaseHandlerErrorsProtocol {
    func handlerError(_ error: Error) -> HTError {
        guard let realmError = error as? Realm.Error else { return .unknownError(error) }
        switch realmError.code {
        case .fileNotFound: return .databaseError(.fileDBNotFound)
        case .schemaMismatch: return .databaseError(.schemaMismatchError)
        case .fileAccess: return .databaseError(.notAccessDBError)
        default: return .unknownError(error)
        }
    }
}
