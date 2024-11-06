//
//  AuthSettingsProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import HookahTobaccoCore

protocol AuthSettingsProtocol: AuthGettingProtocol {
    func setToken(_ token: String?)
}
