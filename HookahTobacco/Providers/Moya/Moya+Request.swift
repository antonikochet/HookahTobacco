//
//  Moya+Request.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Moya

extension MoyaProviderType {

    @discardableResult
    func request<T: Decodable>(
        object: T.Type,
        target: Target,
        progress: ProgressBlock? = nil,
        completion: @escaping Completion
    ) -> Cancellable {
        request(target,
                callbackQueue: .main,
                progress: progress,
                completion: completion)
    }
}
