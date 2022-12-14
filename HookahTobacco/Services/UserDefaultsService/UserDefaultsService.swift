//
//  UserDefaultsService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

class UserDefaultsService {
    // MARK: - Enum of keys UserDefaults values
    private enum UserDefaultsKeys: String {
        case dataBaseVersion
    }

    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard

    // MARK: - Private methods for working UserDefaults
    private func getValue<T>(key: UserDefaultsKeys) -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }

    private func saveValue<T>(_ value: T, key: UserDefaultsKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}

// MARK: - UserDefaultsServiceProtocol implementation
extension UserDefaultsService: UserDefaultsServiceProtocol {
    func getDataBaseVersion() -> Int {
        return getValue(key: .dataBaseVersion) ?? -1
    }

    func setDataBaseVersion(_ newValue: Int) {
        saveValue(newValue, key: .dataBaseVersion)
    }
}
