//
//  DataBaseNetworkingSettingProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.09.2022.
//

import Foundation

protocol SetDataBaseNetworkingProtocol {
    typealias setDBNetworingCompletion = (Error?) -> Void
    func addManufacturer(_ manufacturer: Manufacturer, completion: setDBNetworingCompletion?)
    func setManufacturer(_ newManufacturer: Manufacturer, completion: setDBNetworingCompletion?)
    func addTobacco(_ tobacco: Tobacco, completion: setDBNetworingCompletion?)
    func setTobacco(_ newTobacco: Tobacco, completion: setDBNetworingCompletion?)
}
