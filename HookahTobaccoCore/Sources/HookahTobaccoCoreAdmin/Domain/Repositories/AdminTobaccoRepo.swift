//
//  AdminTobaccoRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminTobaccoRepoProtocol {
    func create(tobacco: Tobacco, completion: ResultBlock<Tobacco>?)
    func update(tobacco: Tobacco, completion: ResultBlock<Tobacco>?)
}

public final class AdminTobaccoRepo: BaseRepo, AdminTobaccoRepoProtocol {
    public func create(tobacco: Tobacco, completion: ResultBlock<Tobacco>?) {
        let dto = TobaccoRequestDTO(
            id: tobacco.id != -1 ? tobacco.id : nil,
            name: tobacco.name,
            tastes: tobacco.tastes.map { $0.id },
            manufacturer: tobacco.manufacturerID,
            description: tobacco.description,
            line: tobacco.line.id,
            image_url: URL(string: tobacco.imageURL)
        )
        let target = Api.Tobacco.create(dto)
        sendRequest(object: TobaccoDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Tobacco(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(tobacco: Tobacco, completion: ResultBlock<Tobacco>?) {
        let dto = TobaccoRequestDTO(
            id: tobacco.id,
            name: tobacco.name,
            tastes: tobacco.tastes.map { $0.id },
            manufacturer: tobacco.manufacturerID,
            description: tobacco.description,
            line: tobacco.line.id,
            image_url: URL(string: tobacco.imageURL)
        )
        let target = Api.Tobacco.update(id: tobacco.id, dto)
        sendRequest(object: TobaccoDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Tobacco(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
