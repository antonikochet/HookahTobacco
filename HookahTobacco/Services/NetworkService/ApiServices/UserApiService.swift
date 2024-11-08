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
    func receiveFavoriteTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?) {
        let target = Api.Users.getFavoritesTobacco(page: page)
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: target,
                    completion: completion as? ResultBlock)
    }

    func receiveWantToBuyTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?) {
        let target = Api.Users.getBuyToTobacco(page: page)
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: target,
                    completion: completion as? ResultBlock)
    }

    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?) {
        let target = Api.Users.updateFavoriteTobaccos(
            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isFavorite) }
        )
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? ResultBlock)
    }

    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?) {
        let target = Api.Users.updateWantBuyTobaccos(
            tobaccos.map { UpdateTobaccosUser(id: $0.uid, flag: $0.isWantBuy) }
        )
        sendRequest(object: [Tobacco].self, target: target, completion: completion as? ResultBlock)
    }
}
