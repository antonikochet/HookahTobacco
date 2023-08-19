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
    var image: Data? { get }
}

protocol RegistrationServiceProtocol {
    typealias RegistrationServiceCompletion = (HTError?) -> Void
    func checkRegistrationData(email: String?, username: String?, completion: RegistrationServiceCompletion?)
    func registration(user: RegistrationUserProtocol, completion: RegistrationServiceCompletion?)
}
