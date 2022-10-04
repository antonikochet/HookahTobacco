//
//  AuthServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.10.2022.
//

import Foundation

protocol AuthServiceProtocol {
    associatedtype User
    typealias AuthServiceCompletion = (Error?) -> Void
    var isUserLoggerIn: Bool { get }
    var currectUser: User? { get }
    func login(with email: String, password: String, completion: AuthServiceCompletion?)
    func logout(completion: AuthServiceCompletion?)
}
