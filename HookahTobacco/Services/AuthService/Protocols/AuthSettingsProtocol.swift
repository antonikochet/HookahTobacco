//
//  AuthSettingsProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

protocol AuthSettingsProtocol {
    func getToken() -> String?
    func setToken(_ token: String?)
}
