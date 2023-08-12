//
//  DataManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

typealias DataManagerType = DataNetworkingServiceProtocol

protocol DataManagerProtocol {
    typealias ReceiveCompletion<T> = (Result<[T], Error>) -> Void
    typealias Completion = (Error?) -> Void

    func receiveData<T: DataManagerType>(typeData: T.Type, completion: ReceiveCompletion<T>?)
    func receiveTobaccos(for manufacturer: Manufacturer, completion: ReceiveCompletion<Tobacco>?)
    func receiveTastes(at ids: [String], completion: ReceiveCompletion<Taste>?)
    func getUser(completion: ((Result<UserProtocol, Error>) -> Void)?)

    func updateFavorite(for tobacco: Tobacco, completion: Completion?)
}
