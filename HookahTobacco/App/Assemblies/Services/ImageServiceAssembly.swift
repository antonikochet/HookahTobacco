//
//  ImageServiceAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation
import Swinject

class ImageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImageServiceProtocol.self) { _ in
            SandboxImageService()
        }
    }
}
