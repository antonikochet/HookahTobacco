//
//  HandlerErrorPlugin.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.07.2023.
//

import Moya

struct HandlerErrorPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let success):
            if let error = handlerResponse(success) {
                return .failure(error)
            } else {
                return .success(success)
            }
        case .failure(let failure):
            return .failure(failure)
        }
    }

    private func handlerResponse(_ response: Response) -> MoyaError? {
        do {
            _ = try response.filterSuccessfulStatusCodes()
            return nil
        } catch MoyaError.statusCode(let response) {
            return MoyaError.statusCode(response)
        } catch { // не должен сюда заходить
            print(error)
        }
        return nil
    }
}
