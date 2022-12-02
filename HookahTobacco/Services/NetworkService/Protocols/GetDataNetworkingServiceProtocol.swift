//
//  GetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation

typealias GetDataNetworkingServiceCompletion<T> = (Result<T, NetworkError>) -> Void

protocol GetDataNetworkingServiceProtocol {
    func getManufacturers(completion: GetDataNetworkingServiceCompletion<[Manufacturer]>?)
    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getAllTobaccos(completion: GetDataNetworkingServiceCompletion<[Tobacco]>?)
    func getAllTastes(completion: GetDataNetworkingServiceCompletion<[Taste]>?)
    func getAllTobaccoLines(completion: GetDataNetworkingServiceCompletion<[TobaccoLine]>?)
    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?)
}
