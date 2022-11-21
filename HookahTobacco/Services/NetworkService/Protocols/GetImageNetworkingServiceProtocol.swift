//
//  GetImageNetworkingServiceProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol GetImageNetworkingServiceProtocol {
    func getImage(for type: ImageNetworkingDataProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
