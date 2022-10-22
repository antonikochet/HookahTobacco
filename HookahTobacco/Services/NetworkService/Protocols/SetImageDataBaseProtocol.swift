//
//  SetImageDataBaseProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol SetImageDataBaseProtocol {
    typealias Completion = (Error?) -> Void
    
    func addImage(by fileURL: URL, for image: NamedFireStorage, completion: @escaping Completion)
    func setImage(from oldImage: NamedFireStorage, to newURL: URL, for newImage: NamedFireStorage, completion: @escaping Completion)
    func setImageName(from oldImage: NamedFireStorage, to newImage: NamedFireStorage, completion: @escaping Completion)
}
