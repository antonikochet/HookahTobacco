//
//  GetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation

typealias GetDataNetworkingServiceCompletion<T> = (Result<T, NetworkError>) -> Void

protocol GetDataNetworkingServiceProtocol {
    func receiveData<T: DataNetworkingServiceProtocol>(type: T.Type,
                                                       completion: GetDataNetworkingServiceCompletion<[T]>?)
    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getUser(completion: GetDataNetworkingServiceCompletion<UserProtocol>?)
    func getFavoriteTobaccos(completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getWantToBuyTobaccos(completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?)
}
