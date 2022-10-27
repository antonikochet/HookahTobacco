//
//
//  TobaccoListAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation
import Swinject

class TobaccoListAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(TobaccoListRouterProtocol.self) { (r, appRouter: AppRouterProtocol) in
            let router = TobaccoListRouter(appRouter)
            return router
        }
        
        container.register(TobaccoListInteractorInputProtocol.self) { (r, isAdminMode: Bool) in
            //here resolve dependency injection
            let getDataManager = r.resolve(GetDataBaseNetworkingProtocol.self)!
            let getImageManager = r.resolve(GetImageDataBaseProtocol.self)!
            
            return TobaccoListInteractor(isAdminMode,
                                         getDataManager: getDataManager,
                                         getImageManager: getImageManager)
        }
        
        container.register(TobaccoListViewOutputProtocol.self) { r in
            let presenter = TobaccoListPresenter()
            return presenter
        }
        
        container.register(TobaccoListViewController.self) { (r, appRouter: AppRouterProtocol, isAdminMode: Bool) in
            let view = TobaccoListViewController()
            let presenter = r.resolve(TobaccoListViewOutputProtocol.self) as! TobaccoListPresenter
            let interactor = r.resolve(TobaccoListInteractorInputProtocol.self, argument: isAdminMode) as! TobaccoListInteractor
            let router = r.resolve(TobaccoListRouterProtocol.self, argument: appRouter)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
