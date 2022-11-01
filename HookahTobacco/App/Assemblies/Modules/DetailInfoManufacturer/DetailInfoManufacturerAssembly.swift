//
//
//  DetailInfoManufacturerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//
//

import Foundation
import Swinject

class DetailInfoManufacturerAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(DetailInfoManufacturerRouterProtocol.self) { (r,
                                                                         appRouter: AppRouterProtocol) in
            let router = DetailInfoManufacturerRouter(appRouter)
            return router
        }
        
        container.register(DetailInfoManufacturerInteractorInputProtocol.self) { (r,
                                                                                  manufacturer: Manufacturer) in
            //here resolve dependency injection
            let getDataManager = r.resolve(GetDataBaseNetworkingProtocol.self)!
            let getImageManager = r.resolve(GetImageDataBaseProtocol.self)!
            
            return DetailInfoManufacturerInteractor(manufacturer,
                                                    getDataManager: getDataManager,
                                                    getImageManager: getImageManager)
        }
        
        container.register(DetailInfoManufacturerViewOutputProtocol.self) { r in
            let presenter = DetailInfoManufacturerPresenter()
            return presenter
        }
        
        container.register(DetailInfoManufacturerViewController.self) { (r,
                                                                         appRouter: AppRouterProtocol,
                                                                         manufacturer: Manufacturer) in
            let view = DetailInfoManufacturerViewController()
            let presenter = r.resolve(DetailInfoManufacturerViewOutputProtocol.self) as! DetailInfoManufacturerPresenter
            let interactor = r.resolve(DetailInfoManufacturerInteractorInputProtocol.self,
                                       argument: manufacturer) as! DetailInfoManufacturerInteractor
            let router = r.resolve(DetailInfoManufacturerRouterProtocol.self, argument: appRouter)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
