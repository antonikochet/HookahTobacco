//
//
//  AddManufacturerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

class AddManufacturerAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AddManufacturerRouterProtocol.self) { (r, appRouter: AppRouterProtocol) in
            let router = AddManufacturerRouter(appRouter)
            return router
        }
        
        container.register(AddManufacturerInteractorInputProtocol.self) { (r, manufacturer: Manufacturer?) in
            //here resolve dependency injection
            let setNetworkManager = r.resolve(SetDataBaseNetworkingProtocol.self)!
            let setImageManager = r.resolve(SetImageDataBaseProtocol.self)!
            if let manufacturer = manufacturer {
                let getImageManager = r.resolve(GetImageDataBaseProtocol.self)!
                return AddManufacturerInteractor(manufacturer,
                                                 setNetworkManager: setNetworkManager,
                                                 setImageManager: setImageManager,
                                                 getImageManager: getImageManager)
            }
            return AddManufacturerInteractor(setNetworkManager: setNetworkManager,
                                             setImageManager: setImageManager)
        }
        
        container.register(AddManufacturerViewOutputProtocol.self) { r in
            let presenter = AddManufacturerPresenter()
            return presenter
        }
        
        container.register(AddManufacturerViewController.self) { (r, appRouter: AppRouterProtocol, manufacturer: Manufacturer?) in
            let view = AddManufacturerViewController()
            let presenter = r.resolve(AddManufacturerViewOutputProtocol.self) as! AddManufacturerPresenter
            let interactor = r.resolve(AddManufacturerInteractorInputProtocol.self, argument: manufacturer) as! AddManufacturerInteractor
            let router = r.resolve(AddManufacturerRouterProtocol.self, argument: appRouter)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
