//
//  SetImageDataBaseProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

protocol SetImageDataBaseProtocol {
    typealias Completion = (Error?) -> Void
    
    func setImage(_ image: Data, for type: NamedFireStorage, completion: @escaping Completion)
    func setImage(_ urlFile: URL, for type: NamedFireStorage, completion: @escaping Completion)
}
