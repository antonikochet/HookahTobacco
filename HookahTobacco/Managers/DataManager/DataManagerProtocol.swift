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
    func receiveTobaccos(for manufacturer: Manufacturer, completion: ReceiveCompletion<Tobacco>?)
    func receiveTastes(at ids: [Int], completion: ReceiveCompletion<Taste>?)
    func getUser(completion: ((Result<UserProtocol, HTError>) -> Void)?)
    func receiveFavoriteTobaccos(completion: ReceiveCompletion<Tobacco>?)
    func receiveWantBuyTobaccos(completion: ReceiveCompletion<Tobacco>?)

    func updateFavorite(for tobacco: Tobacco, completion: Completion?)
}
