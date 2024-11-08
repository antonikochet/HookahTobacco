//
//  RegistrationServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation
import HookahTobaccoCore

protocol RegistrationServiceProtocol {
    func checkRegistrationData(email: String, username: String, password: String, completion: BlockWithParam<HTError?>?)
    func registration(user: RegistrationUser, completion: BlockWithParam<HTError?>?)
}
