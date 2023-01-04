//
//  RegistrationServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation

protocol RegistrationServiceProtocol {
    typealias RegistrationServiceCompletion = (AuthError?) -> Void
    func registration(email: String, password: String, completion: RegistrationServiceCompletion?)
    func sendRegistrationUserData(firstName: String, lastName: String, photo: Data?,
                                  completion: RegistrationServiceCompletion?)
}
