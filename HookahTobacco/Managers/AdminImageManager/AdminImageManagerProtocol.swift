//
//  AdminImageManagerProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation

protocol AdminImageManagerProtocol {
    typealias AdminImageManagerCompletion = (Error?) -> Void

    func addImage(by fileURL: URL,
                  for image: NamedImageManager,
                  completion: AdminImageManagerCompletion?)
    func setImage(from oldImage: NamedImageManager,
                  to newURL: URL,
                  for newImage: NamedImageManager,
                  completion: AdminImageManagerCompletion?)
    func setImageName(from oldImage: NamedImageManager,
                      to newImage: NamedImageManager,
                      completion: AdminImageManagerCompletion?)
}
