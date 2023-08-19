//
//  RealmProviderProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import RealmSwift

protocol RealmProviderProtocol {

    typealias FailureCompletionBlock = (Error) -> Void

    func read(type: Object.Type,
              completion: DataBaseObjectsHandler<ThreadSafe<Results<Object>>>?)
    func write(element: Object,
               completion: CompletionBlock?,
               failure: FailureCompletionBlock?)
    func write<S>(elements: S,
                  completion: CompletionBlock?,
                  failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object
    func update(element: Object,
                completion: CompletionBlock?,
                failure: FailureCompletionBlock?)
    func update<S>(elements: S,
                   completion: CompletionBlock?,
                   failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object
    func delete(object: Object,
                completion: CompletionBlock?,
                failure: FailureCompletionBlock?)
    func delete<S>(objects: S,
                   completion: CompletionBlock?,
                   failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object
}
