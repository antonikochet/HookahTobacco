//
//  ImageManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

enum NamedImageManager {
    case manufacturerImage(nameImage: String)
    case tobaccoImage(manufacturer: String, name: String)
}

protocol ImageManagerProtocol {
    func getImage(for url: String, completion: @escaping (Result<Data, HTError>) -> Void)
}
