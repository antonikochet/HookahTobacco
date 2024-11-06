//
//  GlobalConstant.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

typealias VoidBlock = () -> Void
typealias BlockWithParam<T> = (T) -> Void
public typealias ResultBlockWithError<T, E: Error> = (Result<T, E>) -> Void
public typealias ResultBlock<T> = ResultBlockWithError<T, DomainError>

struct GlobalConstant {
    static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
