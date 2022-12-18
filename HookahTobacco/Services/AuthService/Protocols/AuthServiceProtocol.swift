//
//  AuthServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.10.2022.
//

import Foundation

protocol UserProtocol {
    var uid: String { get }
    var email: String? { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var isAdmin: Bool { get }
    var isAnonymous: Bool { get }
}

protocol AuthServiceProtocol {
    typealias AuthServiceCompletion = (AuthError?) -> Void
    var isUserLoggerIn: Bool { get }
    var currectUser: UserProtocol? { get }
    func login(with email: String, password: String, completion: AuthServiceCompletion?)
    func logout(completion: AuthServiceCompletion?)
}
