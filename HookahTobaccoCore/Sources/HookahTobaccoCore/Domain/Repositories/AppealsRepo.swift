//
//  AppealsRepo.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import HookahTobaccoNetwork

public protocol AppealsRepoProtocol {
    func fetchThemes(completion: ResultBlock<ThemesAppeal>?)
    func createAppeal(_ appeal: CreateAppealEntity, completion: ResultBlock<CreatedAppeal>?)
}

public final class AppealsRepo: BaseRepo, AppealsRepoProtocol {
    public func fetchThemes(completion: ResultBlock<ThemesAppeal>?) {
        let target = Api.Appeals.getThemes
        sendRequest(
            object: ThemesAppealDTO.self,
            target: target
        ) { result in
            switch result {
            case .success(let dto):
                let result = ThemesAppeal(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func createAppeal(_ appeal: CreateAppealEntity, completion: ResultBlock<CreatedAppeal>?) {
        let request = CreateAppealRequestDTO(entity: appeal)
        let target = Api.Appeals.createAppeal(request)
        sendRequest(
            object: CreatedAppealDTO.self,
            target: target
        ) { result in
            switch result {
            case .success(let dto):
                let result = CreatedAppeal(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

private extension CreateAppealRequestDTO {
    init(entity: CreateAppealEntity) {
        self.init(
            name: entity.name,
            email: entity.email,
            user: entity.user,
            theme: entity.theme,
            message: entity.message,
            contents: entity.contents
        )
    }
}
