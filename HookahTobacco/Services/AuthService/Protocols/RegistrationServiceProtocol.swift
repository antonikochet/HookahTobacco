//
//  RegistrationServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation

protocol RegistrationUserProtocol: Encodable {
    var username: String { get }
    var email: String { get }
    var password: String { get }
    var repeatPassword: String { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var dateOfBirth: Date? { get }
    var gender: Gender? { get }
}

protocol RegistrationServiceProtocol {
    func checkRegistrationData(email: String, username: String, password: String, completion: CompletionBlockWithParam<HTError?>?)
    func registration(user: RegistrationUserProtocol, completion: CompletionBlockWithParam<HTError?>?)
}
