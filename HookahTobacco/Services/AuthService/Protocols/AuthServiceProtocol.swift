//
//  AuthServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.10.2022.
//

import Foundation
import HookahTobaccoCore

protocol AuthServiceProtocol {
    typealias AuthServiceCompletion = (DomainError?) -> Void
    var isLoggedIn: Bool { get }
    func login(with name: String, password: String, completion: AuthServiceCompletion?)
    func logout(completion: AuthServiceCompletion?)
}
