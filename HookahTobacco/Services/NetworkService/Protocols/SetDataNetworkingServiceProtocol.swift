//
//  SetDataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.09.2022.
//

import Foundation

protocol SetDataNetworkingServiceProtocol {
    typealias SetDataNetworingCompletion = (NetworkError?) -> Void
    func addManufacturer(_ manufacturer: Manufacturer, completion: SetDataNetworingCompletion?)
    func setManufacturer(_ newManufacturer: Manufacturer, completion: SetDataNetworingCompletion?)
    func addTobacco(_ tobacco: Tobacco, completion: ((Result<String, NetworkError>) -> Void)?)
    func setTobacco(_ newTobacco: Tobacco, completion: SetDataNetworingCompletion?)
    func addTaste(_ taste: Taste, completion: SetDataNetworingCompletion?)
    func setTaste(_ taste: Taste, completion: SetDataNetworingCompletion?)
}
