//
//  AdminImageManagerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation
import Swinject

class AdminImageManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AdminImageManager.self) { resolver in
            AdminImageManager(
                setImageNetworingService: resolver.resolve(SetImageNetworkingServiceProtocol.self)!,
                getImageNetworingService: resolver.resolve(GetImageNetworkingServiceProtocol.self)!,
                imageService: resolver.resolve(ImageServiceProtocol.self)!)
        }
        .inObjectScope(.container)

        container.register(AdminImageManagerProtocol.self) { resolver in
            resolver.resolve(AdminImageManager.self)!
        }
    }
}
