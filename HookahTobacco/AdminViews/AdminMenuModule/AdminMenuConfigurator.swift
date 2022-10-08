//
//
//  AdminMenuConfigurator.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import UIKit

class AdminMenuConfigurator: ConfiguratorProtocol {
    func configure() -> UIViewController {
        
        let view = AdminMenuViewController()
        let presenter = AdminMenuPresenter()
        let interactor = AdminMenuInteractor()
        let router = AdminMenuRouter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.viewController = view
        
        return view
    }
}
