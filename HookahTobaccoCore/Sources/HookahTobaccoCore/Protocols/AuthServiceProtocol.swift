//
//  AuthServiceProtocol.swift
//  
//
//  Created by антон кочетков on 05.10.2022.
//

public protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    func login(with name: String, password: String) async throws
    func logout(completion: BlockWithParam<DomainError?>?)
}
