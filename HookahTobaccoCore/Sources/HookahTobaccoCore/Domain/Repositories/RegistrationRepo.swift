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

private extension RegistrationUserDTO {
    init(entity: RegistrationUser) {
        var date_of_birth: String?
        if let dateOfBirth = entity.dateOfBirth {
            date_of_birth = TextFormatter.dateToString(dateOfBirth, format: .shortDate)
        }
        self.init(
            username: entity.username,
            email: entity.email,
            password1: entity.password,
            password2: entity.repeatPassword,
            first_name: entity.firstName,
            last_name: entity.lastName,
            date_of_birth: date_of_birth,
            gender: entity.gender?.rawValue
        )
    }
}
