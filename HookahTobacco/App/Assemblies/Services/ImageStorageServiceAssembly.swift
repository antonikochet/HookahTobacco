//
//  ImageStorageServiceAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation
import Swinject

class ImageStorageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImageStorageServiceProtocol.self) { _ in
            SandboxImageStorageService()
        }
    }
}
