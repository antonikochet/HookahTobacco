//
//
//  LoginAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

class LoginAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LoginRouterProtocol.self) { (r, appRouter: AppRouterProtocol, viewController: LoginViewController) in
            let router = LoginRouter(appRouter, viewController)
            return router
        }
        
        container.register(LoginInteractorInputProtocol.self) { r in
            //here resolve dependency injection
            
            return LoginInteractor()
        }
        
        container.register(LoginViewOutputProtocol.self) { r in
            let presenter = LoginPresenter()
            return presenter
        }
        
        container.register(LoginViewController.self) { (r, appRouter: AppRouterProtocol) in
            let view = LoginViewController()
            let presenter = r.resolve(LoginViewOutputProtocol.self) as! LoginPresenter
            let interactor = r.resolve(LoginInteractorInputProtocol.self) as! LoginInteractor
            let router = r.resolve(LoginRouterProtocol.self, arguments: appRouter, view)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
