//
//  UserSettingsServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

protocol UserSettingsServiceProtocol {
    func getDataBaseVersion() -> Int
    func setDataBaseVersion(_ newValue: Int)
}
