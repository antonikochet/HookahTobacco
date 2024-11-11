//
//  LocalizationProvider.swift
//
//
//  Created by Антон Кочетков on 11.11.2024.
//

public protocol LocalizationProvider {
    func localizedString(forKey key: LocalizationKeys) -> String
}

public enum LocalizationManager {
    public static var provider: LocalizationProvider! = MockLocalizationProvider()
}

internal struct MockLocalizationProvider: LocalizationProvider {
    func localizedString(forKey key: LocalizationKeys) -> String {
        return ""
    }
}
