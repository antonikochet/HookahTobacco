//
//  UserApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

protocol UserNetworkingServiceProtocol {
    func receiveUser(completion: CompletionResultBlock<UserProtocol>?)
//    func updateUser(_ user: UserProtocol, completion: CompletionResultBlock<UserProtocol>?)
    func receiveFavoriteTobaccos(completion: CompletionResultBlock<[Tobacco]>?)
    func receiveWantToBuyTobaccos(completion: CompletionResultBlock<[Tobacco]>?)
//    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?)
//    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?)
}

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

    func receiveFavoriteTobaccos(completion: CompletionResultBlock<[Tobacco]>?) {
        let target = Api.Users.getFavoritesTobacco
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? CompletionResultBlock)
    }

    func receiveWantToBuyTobaccos(completion: CompletionResultBlock<[Tobacco]>?) {
        let target = Api.Users.getBuyToTobacco
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? CompletionResultBlock)
    }
}
