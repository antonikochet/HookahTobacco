//
//  DataBaseServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import Foundation

typealias DataBaseOperationCompletion = () -> Void
typealias DataBaseObjectsHandler<T> = (T) -> Void
typealias DataBaseErrorHandler = ((DataBaseError) -> Void)

protocol DataBaseServiceProtocol {
    func read<T>(type: T.Type,
                 completion: DataBaseObjectsHandler<[T]>?,
                 failure: DataBaseErrorHandler?)
    func add<T>(entity: T,
                completion: DataBaseOperationCompletion?,
                failure: DataBaseErrorHandler?)
    func add<T: Sequence>(entities: T,
                          completion: DataBaseOperationCompletion?,
                          failure: DataBaseErrorHandler?)
    func update<T>(entity: T,
                   completion: DataBaseOperationCompletion?,
                   failure: DataBaseErrorHandler?)
    func update<T: Sequence>(entities: T,
                             completion: DataBaseOperationCompletion?,
                             failure: DataBaseErrorHandler?)
}
