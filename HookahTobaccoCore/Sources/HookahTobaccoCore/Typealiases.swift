//
//  Typealiases.swift
//
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

public typealias VoidBlock = () -> Void
public typealias BlockWithParam<T> = (T) -> Void
public typealias ResultBlockWithError<T, E: Error> = (Result<T, E>) -> Void
public typealias ResultBlock<T> = ResultBlockWithError<T, DomainError>
