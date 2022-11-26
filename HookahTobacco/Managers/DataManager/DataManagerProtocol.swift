//
//  DataManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

typealias ReceiveDataManagerCompletion<T> = (Result<[T], Error>) -> Void

protocol DataManagerProtocol {
    func receiveData<T>(typeData: T.Type, completion: ReceiveDataManagerCompletion<T>?)
    func receiveTobaccos(for manufacturer: Manufacturer, completion: ReceiveDataManagerCompletion<Tobacco>?)
    func receiveTastes(at ids: [Int], completion: ReceiveDataManagerCompletion<Taste>?)
}
