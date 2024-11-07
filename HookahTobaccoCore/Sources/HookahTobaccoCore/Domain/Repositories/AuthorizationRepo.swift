//
//  AuthorizationRepo.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

import HookahTobaccoNetwork

public protocol AuthorizationRepoProtocol {
    func login(with name: String, password: String, completion: ResultBlock<LoginEntity>?)
    func logout(completion: BlockWithParam<DomainError?>?)
}

public final class AuthorizationRepo: BaseRepo, AuthorizationRepoProtocol {
    public func login(with name: String, password: String, completion: ResultBlock<LoginEntity>?) {
        let isEmail = name.isEmailValid()
        let request = LoginRequestDTO(email: isEmail ? name : "",
                                      username: isEmail ? "" : name,
                                      password: password)
        let target = Api.Authorization.login(request)
        sendRequest(object: LoginDTO.self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = LoginEntity(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func logout(completion: BlockWithParam<DomainError?>?) {
        let target = Api.Authorization.logout
        sendRequest(object: EmptyDTO.self, target: target) { result in
            switch result {
            case .success:
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
}
