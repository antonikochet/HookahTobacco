//
//  AdminDataManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation

protocol AdminDataManagerProtocol {
    typealias AdminDataManagerCompletion<T> = (Result<T, Error>) -> Void

    func addData<T: DataManagerType>(_ data: T, completion: AdminDataManagerCompletion<T>?)
    func setData<T: DataManagerType>(_ data: T, completion: AdminDataManagerCompletion<T>?)
}
