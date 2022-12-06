//
//  ImageManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

enum NamedImageManager {
    case manufacturerImage(nameImage: String)
    case tobaccoImage(manufacturer: String, uid: String, type: TobaccoImageType)
}

protocol ImageManagerProtocol {
    func getImage(for type: NamedImageManager, completion: @escaping (Result<Data, Error>) -> Void)
}
