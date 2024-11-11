//
//  UserSettingsService.swift
//
//
//  Created by Антон Кочетков on 10.11.2024.
//

public final class UserSettingsService {

    // MARK: - Private properties
    private let localStorage: LocalStorageProtocol
    private let localSecurityStorage: LocalSecurityStorageProtocol

    // MARK: - Init
    public init(
        localStorage: LocalStorageProtocol,
        localSecurityStorage: LocalSecurityStorageProtocol
    ) {
        self.localStorage = localStorage
        self.localSecurityStorage = localSecurityStorage
    }
}

private extension UserSettingsService {
    // MARK: - Enum of keys Local Storage values
    private enum LocalStorageKeys: String, LocalStorageKeyProtocol {
        case none
        
        var key: String {
            rawValue
        }
    }
    // MARK: - Enum of keys Security Storage values
    private enum LocalSecurityStorageKeys: String, LocalStorageKeyProtocol {
        case token
        
        var key: String {
            rawValue
        }
    }
}

// MARK: - AuthSettingsProtocol implementation
extension UserSettingsService: AuthSettingsProtocol {
    public func getToken() -> String? {
        localSecurityStorage.getValue(key: LocalSecurityStorageKeys.token)
    }

    public func setToken(_ token: String?) {
        if let token {
            localSecurityStorage.setValue(token, key: LocalSecurityStorageKeys.token)
        } else {
            localSecurityStorage.deleteValue(key: LocalSecurityStorageKeys.token)
        }
    }
}
