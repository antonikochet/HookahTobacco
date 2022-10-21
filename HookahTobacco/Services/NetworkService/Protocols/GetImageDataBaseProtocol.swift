//
//  GetImageDataBaseProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol GetImageDataBaseProtocol {
    func getImage(for type: NamedFireStorage, completion: @escaping (Result<Data, Error>) -> Void)
}
