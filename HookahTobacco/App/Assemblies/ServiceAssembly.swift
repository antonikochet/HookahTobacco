//
//  AssemblesServices.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import Foundation
import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(SetDataBaseNetworkingProtocol.self) { _ in
            FireBaseSetNetworkManager()
        }
        container.register(GetDataBaseNetworkingProtocol.self) { _ in
            FireBaseGetNetworkManager()
        }
        container.register(GetImageDataBaseProtocol.self) { _ in
            FireStorageGetImageManager()
        }
        container.register(SetImageDataBaseProtocol.self) { _ in
            FireStorageSetImageManager()
        }
    }
}
