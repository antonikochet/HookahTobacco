//
//  DataNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.11.2022.
//

import Foundation

protocol DataNetworkingServiceProtocol {
    var uid: String { get set }

    init?(_ data: [String: Any], uid: String)
    func formatterToData() -> [String: Any]
}
