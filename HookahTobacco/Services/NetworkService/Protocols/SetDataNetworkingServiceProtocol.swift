//
//  SetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.09.2022.
//

import Foundation

protocol SetDataNetworkingServiceProtocol {
    typealias SetDataNetworingCompletion = (NetworkError?) -> Void
    typealias AddDataNetworkingCompletion = (Result<String, NetworkError>) -> Void
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: AddDataNetworkingCompletion?)
    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: SetDataNetworingCompletion?)
    func setDBVersion(_ newVersion: Int, completion: SetDataNetworingCompletion?)
}
