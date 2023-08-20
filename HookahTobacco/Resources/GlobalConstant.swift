//
//  GlobalConstant.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

typealias CompletionBlock = () -> Void
typealias CompletionBlockWithParam<T> = (T) -> Void
typealias CompletionResultBlockWithError<T, E: Error> = (Result<T, E>) -> Void
typealias CompletionResultBlock<T> = CompletionResultBlockWithError<T, HTError>

struct GlobalConstant {
    static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
