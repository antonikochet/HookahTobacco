//
//  GetImageDataBaseProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol GetImageDataBaseProtocol {
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}
