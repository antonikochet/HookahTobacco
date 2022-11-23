//
//  RealmProviderProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import RealmSwift

protocol RealmProviderProtocol {
    func read(type: Object.Type,
              completion: DataBaseObjectsHandler<ThreadSafe<Results<Object>>>?)
    func write(element: Object,
               completion: DataBaseOperationCompletion?,
               failure: DataBaseErrorHandler?)
    func write<S>(elements: S,
                  completion: DataBaseOperationCompletion?,
                  failure: DataBaseErrorHandler?) where S: Sequence, S.Element: Object
    func update(element: Object,
                completion: DataBaseOperationCompletion?,
                failure: DataBaseErrorHandler?)
    func update<S>(elements: S,
                   completion: DataBaseOperationCompletion?,
                   failure: DataBaseErrorHandler?) where S: Sequence, S.Element: Object
    func delete(object: Object,
                completion: DataBaseOperationCompletion?,
                failure: DataBaseErrorHandler?)
    func delete<S>(objects: S,
                   completion: DataBaseOperationCompletion?,
                   failure: DataBaseErrorHandler?) where S: Sequence, S.Element: Object
}
