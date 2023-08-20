//
//  GetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation

typealias GetDataNetworkingServiceCompletion<T> = (Result<T, HTError>) -> Void

protocol GetDataNetworkingServiceProtocol {
    func receiveData<T: DataNetworkingServiceProtocol>(type: T.Type,
                                                       completion: GetDataNetworkingServiceCompletion<[T]>?)
    func getImage(for url: String, completion: CompletionResultBlock<Data>?)
    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?)
}
