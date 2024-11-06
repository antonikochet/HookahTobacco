//
//  AuthSettingsProtocol.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

public protocol AuthSettingsProtocol: AuthGettingProtocol {
    func setToken(_ token: String?)
}
