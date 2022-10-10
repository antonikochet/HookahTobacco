//
//
//  AdminMenuAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

class AdminMenuAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AdminMenuRouterProtocol.self) { (r, appAssembler: AppRouterProtocol) in
            let router = AdminMenuRouter(appAssembler)
            return router
        }
        
        container.register(AdminMenuInteractorInputProtocol.self) { r in
            //here resolve dependency injection
            
            return AdminMenuInteractor()
        }
        
        container.register(AdminMenuViewOutputProtocol.self) { r in
            let presenter = AdminMenuPresenter()
            return presenter
        }
        
        container.register(AdminMenuViewController.self) { (r, appAssembler: AppRouterProtocol) in
            let view = AdminMenuViewController()
            let presenter = r.resolve(AdminMenuViewOutputProtocol.self) as! AdminMenuPresenter
            let interactor = r.resolve(AdminMenuInteractorInputProtocol.self) as! AdminMenuInteractor
            let router = r.resolve(AdminMenuRouterProtocol.self, argument: appAssembler)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
