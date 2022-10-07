//
//
//  LoginConfigurator.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

class LoginConfigurator: ConfiguratorProtocol {
    func configure() -> UIViewController {
        
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
}
