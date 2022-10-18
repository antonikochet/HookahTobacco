//
//
//  ManufacturerListAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation
import Swinject

class ManufacturerListAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(ManufacturerListRouterProtocol.self) { (r, appRouter: AppRouterProtocol) in
            let router = ManufacturerListRouter(appRouter)
            return router
        }
        
        container.register(ManufacturerListInteractorInputProtocol.self) { r  in
            //here resolve dependency injection
            let getDataManager = r.resolve(GetDataBaseNetworkingProtocol.self)!
            let getImageManager = r.resolve(GetImageDataBaseProtocol.self)!
            
            return ManufacturerListInteractor(getDataManager: getDataManager,
                                              getImageManager: getImageManager)
        }
        
        container.register(ManufacturerListViewOutputProtocol.self) { r in
            let presenter = ManufacturerListPresenter()
            return presenter
        }
        
        container.register(ManufacturerListViewController.self) { (r, appRouter: AppRouterProtocol) in
            let view = ManufacturerListViewController()
            let presenter = r.resolve(ManufacturerListViewOutputProtocol.self) as! ManufacturerListPresenter
            let interactor = r.resolve(ManufacturerListInteractorInputProtocol.self) as! ManufacturerListInteractor
            let router = r.resolve(ManufacturerListRouterProtocol.self, argument: appRouter)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
