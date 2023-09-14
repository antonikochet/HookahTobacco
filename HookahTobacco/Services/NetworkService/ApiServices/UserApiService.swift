//
//  UserApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

final class UserApiService: BaseApiService {

}

extension UserApiService: UserNetworkingServiceProtocol {
    func receiveUser(completion: CompletionResultBlock<UserProtocol>?) {
        let target = Api.Users.get
        sendRequest(object: User.self, target: target) { user in
            completion?(.success(user))
        } failure: { error in
            completion?(.failure(error))
        }
    }

    func updateUser(_ user: RegistrationUserProtocol, completion: CompletionResultBlock<UserProtocol>?) {
        let target = Api.Users.patch(user)
        sendRequest(object: User.self, target: target) { user in
            completion?(.success(user))
        } failure: { error in
            completion?(.failure(error))
        }
    }

    func receiveFavoriteTobaccos(page: Int, completion: CompletionResultBlock<PageResponse<Tobacco>>?) {
        let target = Api.Users.getFavoritesTobacco(page: page)
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: target,
                    completion: completion as? CompletionResultBlock)
    }

    func receiveWantToBuyTobaccos(page: Int, completion: CompletionResultBlock<PageResponse<Tobacco>>?) {
        let target = Api.Users.getBuyToTobacco(page: page)
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: target,
                    completion: completion as? CompletionResultBlock)
    }

    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?) {
        let target = Api.Users.updateFavoriteTobaccos(
            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isFavorite) }
        )
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? CompletionResultBlock)
    }

    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?) {
        let target = Api.Users.updateWantBuyTobaccos(
            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isWantBuy) }
        )
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? CompletionResultBlock)
    }
}
