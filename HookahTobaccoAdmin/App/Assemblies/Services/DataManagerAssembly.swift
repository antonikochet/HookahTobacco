//
//  DataManagerAssembly.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import Swinject

class DataManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DataManager.self) { resolver in
            DataManager(imageService: resolver.resolve(ImageStorageServiceProtocol.self)!)
        }
        .inObjectScope(.container)
        
        container.register(ObserverProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
    }
}
