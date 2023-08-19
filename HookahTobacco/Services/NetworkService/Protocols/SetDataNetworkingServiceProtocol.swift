//
//  SetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.09.2022.
//

import Foundation

protocol SetDataNetworkingServiceProtocol {
    typealias DataNetworkingCompletion<T: DataNetworkingServiceProtocol> = (Result<T, HTError>) -> Void
    typealias SetDataNetworingCompletion = (HTError?) -> Void
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: DataNetworkingCompletion<T>?)
    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: DataNetworkingCompletion<T>?)
    func setDBVersion(_ newVersion: Int, completion: SetDataNetworingCompletion?)
}
