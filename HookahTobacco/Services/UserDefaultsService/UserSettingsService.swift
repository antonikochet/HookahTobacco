//
//  UserSettingsService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import KeychainAccess

class UserSettingsService {

    // MARK: - Private properties
    private let userDefaults: UserDefaults
    private let keychain: Keychain

    // MARK: - Init
    init(userDefaults: UserDefaults = .standard,
         keychain: Keychain = Keychain()) {
        self.userDefaults = userDefaults
        self.keychain = keychain
    }

    // MARK: - Private methods for working UserDefaults
    private func getValue<T>(key: UserDefaultsKeys) -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }

    private func saveValue<T>(_ value: T, key: UserDefaultsKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    private func removeValue(key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    // MARK: - Private methods for working Keychain
    private func getValue<T>(key: KeychainKeys) -> T? {
        keychain[key.rawValue] as? T
    }

    private func saveValue<T>(_ value: T, key: KeychainKeys) {
        // TODO: поправить при работе с объектами
        keychain[key.rawValue] = value as? String
    }

    private func removeValue(key: KeychainKeys) {
        keychain[key.rawValue] = nil
    }
}

private extension UserSettingsService {
    // MARK: - Enum of keys UserDefaults values
    private enum UserDefaultsKeys: String {
        case dataBaseVersion
    }
    // MARK: - Enum of keys Keychain values
    private enum KeychainKeys: String {
        case token
    }
}

// MARK: - UserSettingsServiceProtocol implementation
extension UserSettingsService: UserSettingsServiceProtocol {
    func getDataBaseVersion() -> Int {
        return getValue(key: .dataBaseVersion) ?? -1
    }

    func setDataBaseVersion(_ newValue: Int) {
        saveValue(newValue, key: .dataBaseVersion)
    }
}

// MARK: - AuthSettingsProtocol implementation
extension UserSettingsService: AuthSettingsProtocol {
    func getToken() -> String? {
        return getValue(key: .token)
    }

    func setToken(_ token: String?) {
        if let token {
            saveValue(token, key: .token)
        } else {
            removeValue(key: .token)
        }
    }
}
