//
//  ImageManagerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 06.12.2022.
//

import Foundation
import Swinject

class ImageManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImageManager.self) { resolver in
            resolver.resolve(AdminImageManager.self)!
        }
        .inObjectScope(.container)

        container.register(ImageManagerProtocol.self) { resolver in
            resolver.resolve(ImageManager.self)!
        }
    }
}
