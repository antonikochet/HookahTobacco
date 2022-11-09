//
//  DataBaseNetworkingSettingProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.09.2022.
//

import Foundation

protocol SetDataBaseNetworkingProtocol {
    typealias setDBNetworingCompletion = (NetworkError?) -> Void
    func addManufacturer(_ manufacturer: Manufacturer, completion: setDBNetworingCompletion?)
    func setManufacturer(_ newManufacturer: Manufacturer, completion: setDBNetworingCompletion?)
    func addTobacco(_ tobacco: Tobacco, completion: ((Result<String, NetworkError>) -> Void)?)
    func setTobacco(_ newTobacco: Tobacco, completion: setDBNetworingCompletion?)
}
