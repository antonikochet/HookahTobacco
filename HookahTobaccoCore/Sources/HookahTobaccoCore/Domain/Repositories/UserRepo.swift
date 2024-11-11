//
//  UserRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol UserRepoProtocol {
    func fetchUser(completion: ResultBlock<User>?)
    func updateUser(_ user: RegistrationUser, completion: ResultBlock<User>?)
    
    func fetchAgreementURLs(_ types: [TypeAgreementURLs], completion: ResultBlock<[AgreementURLs]>?)
}

public final class UserRepo: BaseRepo, UserRepoProtocol {
    public func fetchUser(completion: ResultBlock<User>?) {
        let target = Api.Users.get
        sendRequest(object: UserDTO.self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = User(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    public func updateUser(_ user: RegistrationUser, completion: ResultBlock<User>?) {
        let userDTO = RegistrationUserDTO(entity: user)
        let target = Api.Users.patch(userDTO)
        sendRequest(object: UserDTO.self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = User(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

//    func fetchFavoriteTobaccos(page: Int, completion: ResultBlock<Page<Tobacco>>?) {
//        let target = Api.Users.getFavoritesTobacco(page: page)
//        sendRequest(object: PageResponse<Tobacco>.self,
//                    target: target,
//                    completion: completion as? ResultBlock)
//    }

//    func receiveWantToBuyTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?) {
//        let target = Api.Users.getBuyToTobacco(page: page)
//        sendRequest(object: PageResponse<Tobacco>.self,
//                    target: target,
//                    completion: completion as? ResultBlock)
//    }

//    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?) {
//        let target = Api.Users.updateFavoriteTobaccos(
//            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isFavorite) }
//        )
//        sendRequest(object: [Tobacco].self, target: target, completion: completion as? ResultBlock)
//    }

//    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?) {
//        let target = Api.Users.updateWantBuyTobaccos(
//            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isWantBuy) }
//        )
//        sendRequest(object: [Tobacco].self, target: target, completion: completion as? ResultBlock)
//    }

    public func fetchAgreementURLs(_ types: [TypeAgreementURLs], completion: ResultBlock<[AgreementURLs]>?) {
        let target = Api.Users.getUrls(AgreementURLsRequestDTO(urls: types.map { $0.rawValue }))
        sendRequest(object: [AgreementURLsDTO].self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = dto.compactMap { AgreementURLs(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
