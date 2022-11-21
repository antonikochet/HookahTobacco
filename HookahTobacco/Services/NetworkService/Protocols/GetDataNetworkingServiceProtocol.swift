//
//  GetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation

protocol GetDataNetworkingServiceProtocol {
    func getManufacturers(completion: @escaping (Result<[Manufacturer], NetworkError>) -> Void)
    func getTobaccos(for manufacturer: Manufacturer, completion: @escaping (Result<[Tobacco], NetworkError>) -> Void)
    func getAllTobaccos(completion: @escaping (Result<[Tobacco], NetworkError>) -> Void)
    func getAllTastes(completion: @escaping (Result<[Taste], NetworkError>) -> Void)
//    func getTastes(ids: [Int], completion: @escaping (Result<[Taste], NetworkError>) -> Void)
}
