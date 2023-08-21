//
//  Moya+Request.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Moya

typealias MoyaCompletion<T> = (Result<T, Error>) -> Void

extension MoyaProviderType {

    @discardableResult
    func request<T: Decodable>(
        object: T.Type,
        target: Target,
        progress: ProgressBlock? = nil,
        completion: @escaping MoyaCompletion<T>
    ) -> Cancellable {
        request(target, callbackQueue: .main, progress: progress) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(T.self)
                    completion(.success(data))
                } catch {
                    self.showError("\(error)")
                    completion(.failure(error))
                }
            case let .failure(error):
                self.showError("\(error)")
                completion(.failure(error))
            }
        }
    }

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }
}
