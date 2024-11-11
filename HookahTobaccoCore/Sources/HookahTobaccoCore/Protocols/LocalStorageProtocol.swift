//
//  LocalStorageProtocol.swift
//
//
//  Created by Антон Кочетков on 09.11.2024.
//

public protocol LocalStorageKeyProtocol {
    var key: String { get }
}

public protocol LocalStorageProtocol {
    func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key) -> Value?
    func getValue<Key: LocalStorageKeyProtocol, Value: Codable>(key: Key, defaultValue: Value) -> Value
    func setValue<Key: LocalStorageKeyProtocol, Value: Codable>(_ value: Value?, key: Key)
    func deleteValue<Key: LocalStorageKeyProtocol>(key: Key)
}

public protocol LocalSecurityStorageProtocol: LocalStorageProtocol {}
