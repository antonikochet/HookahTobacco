//
//  SetImageDataBaseProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol SetImageNetworkingServiceProtocol {
    typealias Completion = (NetworkError?) -> Void
    
    func addImage(by fileURL: URL, for image: ImageNetworkingDataProtocol, completion: @escaping Completion)
    func setImage(from oldImage: ImageNetworkingDataProtocol, to newURL: URL, for newImage: ImageNetworkingDataProtocol, completion: @escaping Completion)
    func setImageName(from oldImage: ImageNetworkingDataProtocol, to newImage: ImageNetworkingDataProtocol, completion: @escaping Completion)
}
