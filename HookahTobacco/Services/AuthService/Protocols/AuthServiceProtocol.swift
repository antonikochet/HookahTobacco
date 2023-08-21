//
//  AuthServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.10.2022.
//

import Foundation

protocol UserProtocol {
    var uid: Int { get }
    var username: String { get }
    var email: String { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var isAdmin: Bool { get }
    var dateOfBirth: Date? { get }
}

protocol AuthServiceProtocol {
    typealias AuthServiceCompletion = (HTError?) -> Void
    var isLoggedIn: Bool { get }
    func login(with name: String, password: String, completion: AuthServiceCompletion?)
    func logout(completion: AuthServiceCompletion?)
}
