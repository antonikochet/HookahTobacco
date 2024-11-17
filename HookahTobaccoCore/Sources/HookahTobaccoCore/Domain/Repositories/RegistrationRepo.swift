//
//  RegistrationRepo.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol RegistrationRepoProtocol {
    func checkRegistrationData(email: String, username: String, password: String) async throws
    func registration(user: RegistrationUser, completion: ResultBlock<LoginEntity>?)
}

public final class RegistrationRepo: BaseRepo, RegistrationRepoProtocol {
    public func checkRegistrationData(email: String, username: String, password: String) async throws {
        let request = CheckRegistrationDTO(email: email, username: username, password: password)
        let target = Api.Registration.check(request)
        _ = try await sendRequest(object: EmptyDTO.self, target: target)
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
