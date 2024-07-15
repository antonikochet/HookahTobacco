//
//  GlobalConstant.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

typealias VoidBlock = () -> Void
typealias BlockWithParam<T> = (T) -> Void
typealias ResultBlockWithError<T, E: Error> = (Result<T, E>) -> Void
typealias ResultBlock<T> = ResultBlockWithError<T, HTError>

struct GlobalConstant {
    static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
