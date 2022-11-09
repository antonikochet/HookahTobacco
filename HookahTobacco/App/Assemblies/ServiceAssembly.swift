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
        
        container.register(NetworkHandlerErrors.self) { _ in
            FireBaseHandlerErrors()
        }
        container.register(SetDataBaseNetworkingProtocol.self) { r in
            FireBaseSetNetworkManager(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataBaseNetworkingProtocol.self) { r in
            FireBaseGetNetworkManager(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetImageDataBaseProtocol.self) { r in
            FireStorageGetImageManager(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(SetImageDataBaseProtocol.self) { r in
            FireStorageSetImageManager(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
    }
}
