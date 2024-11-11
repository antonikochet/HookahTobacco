//
//  RegistrationServiceProtocol.swift
//
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation

public protocol RegistrationServiceProtocol {
    func checkRegistrationData(email: String, username: String, password: String, completion: BlockWithParam<DomainError?>?)
    func registration(user: RegistrationUser, completion: BlockWithParam<DomainError?>?)
}
