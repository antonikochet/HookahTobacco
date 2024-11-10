//
//  KeychainStorage.swift
//
//
//  Created by Антон Кочетков on 09.11.2024.
//

import Foundation
import KeychainAccess

public final class KeychainStorage {
    // MARK: - Private properties
    private let keychain: Keychain
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // MARK: - Init
    public init(
        service: String,
        accessGroup: String? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.keychain = Keychain(service: service, accessGroup: accessGroup)
        self.encoder = encoder
        self.decoder = decoder
    }
}

extension KeychainStorage: LocalSecurityStorageProtocol {
    public func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key) -> Value? {
        switch Value.self {
        case is String.Type:
            return keychain[key.key] as? Value
        default:
            guard let data = keychain[data: key.key] else { return nil }
            return try? decoder.decode(Value.self, from: data)
        }
    }
    
    public func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key, defaultValue: Value) -> Value {
        getValue(key: key) ?? defaultValue
    }
    
    public func setValue<Key: LocalStorageKeyProtocol, Value: Codable>(_ value: Value?, key: Key) {
        guard let value else {
            deleteValue(key: key)
            return
        }
        switch Value.self {
        case is String.Type:
            keychain[key.key] = value as? String
        default:
            let data = try? encoder.encode(value)
            keychain[data: key.key] = data
        }
    }
    
    public func deleteValue<Key: LocalStorageKeyProtocol>(key: Key) {
        keychain[key.key] = nil
    }
}
