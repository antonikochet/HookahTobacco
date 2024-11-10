//
//  UserDefaultsStorage.swift
//
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation

public final class UserDefaultsStorage {
    // MARK: - Private properties
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    private func isCustomType<T>(_ instance: T.Type) -> Bool {
        let typeName = String(reflecting: instance.self)
        return !typeName.starts(with: "Swift.") && !typeName.starts(with: "Foundation.")
    }
}

extension UserDefaultsStorage: LocalStorageProtocol {
    public func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key) -> Value? {
        let value = userDefaults.value(forKey: key.key)
        guard let value else { return nil }
        if isCustomType(Value.self), let data = value as? Data {
            return try? decoder.decode(Value.self, from: data)
        } else {
            return value as? Value
        }
    }
    
    public func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key, defaultValue: Value) -> Value {
        getValue(key: key) ?? defaultValue
    }
    
    public func setValue<Key: LocalStorageKeyProtocol, Value: Codable>(_ value: Value?, key: Key) {
        if value != nil {
            if isCustomType(Value.self) {
                let data = try? encoder.encode(value)
                userDefaults.set(data, forKey: key.key)
            } else {
                userDefaults.set(value, forKey: key.key)
            }
        } else {
            deleteValue(key: key)
        }
    }
    
    public func deleteValue<Key: LocalStorageKeyProtocol>(key: Key) {
        userDefaults.removeObject(forKey: key.key)
    }
}
