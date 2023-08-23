//
//  DataManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

typealias DataManagerType = DataNetworkingServiceProtocol

protocol DataManagerProtocol {
    typealias ReceiveCompletion<T> = (Result<[T], HTError>) -> Void
    typealias Completion = (HTError?) -> Void

    func receiveData<T: DataManagerType>(typeData: T.Type, completion: ReceiveCompletion<T>?)
    func receiveImage(for url: String, completion: CompletionResultBlock<Data>?)
    func receiveTastes(at ids: [Int], completion: ReceiveCompletion<Taste>?)
}
