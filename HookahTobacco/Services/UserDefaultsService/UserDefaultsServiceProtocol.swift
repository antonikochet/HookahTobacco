//
//  UserDefaultsServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func getDataBaseVersion() -> Int
    func setDataBaseVersion(_ newValue: Int)
}
