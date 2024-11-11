//
//  RegistrationRepo.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol RegistrationRepoProtocol {
    func checkRegistrationData(email: String, username: String, password: String, completion: BlockWithParam<DomainError?>?)
    func registration(user: RegistrationUser, completion: ResultBlock<LoginEntity>?)
}

public final class RegistrationRepo: BaseRepo, RegistrationRepoProtocol {
    public func checkRegistrationData(
        email: String,
        username: String,
        password: String,
        completion: BlockWithParam<DomainError?>?
    ) {
        let request = CheckRegistrationDTO(email: email, username: username, password: password)
        let target = Api.Registration.check(request)
        sendRequest(object: EmptyDTO.self, target: target) { result in
            switch result {
            case .success:
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    public func registration(user: RegistrationUser, completion: ResultBlock<LoginEntity>?) {
        let userDTO = RegistrationUserDTO(entity: user)
        let target = Api.Registration.registration(userDTO)
        sendRequest(object: LoginDTO.self, target: target) { result in
            switch result {
            case let .success(dto):
                let result = LoginEntity(dto: dto)
                completion?(.success(result))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}
