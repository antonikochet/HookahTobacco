//
//  AppealsApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import Foundation

final class AppealsApiService: BaseApiService {

}

extension AppealsApiService: AppealsNetworkingServiceProtocol {
    func receiveThemes(completion: CompletionResultBlock<ThemesAppealsResponse>?) {
        let target = Api.Appeals.getThemes
        sendRequest(
            object: ThemesAppealsResponse.self,
            target: target,
            completion: completion as? CompletionResultBlock
        )
    }

    func createAppeal(_ appeal: CreateAppealEntity, completion: CompletionBlockWithParam<CreateAppealResponse>?) {
        let request = CreateAppealRequest(entity: appeal)
        let target = Api.Appeals.createAppeal(request)
        sendRequest(
            object: CreateAppealResponse.self,
            target: target,
            completion: completion as? CompletionResultBlock
        )
    }
}
