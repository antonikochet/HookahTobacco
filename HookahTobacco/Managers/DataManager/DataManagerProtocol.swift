//
//  DataManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

typealias DataManagerType = DataNetworkingServiceProtocol

protocol DataManagerProtocol {
    typealias ReceiveDataManagerCompletion<T> = (Result<[T], Error>) -> Void

    func receiveData<T: DataManagerType>(typeData: T.Type, completion: ReceiveDataManagerCompletion<T>?)
    func receiveTobaccos(for manufacturer: Manufacturer, completion: ReceiveDataManagerCompletion<Tobacco>?)
    func receiveTastes(at ids: [String], completion: ReceiveDataManagerCompletion<Taste>?)
}
