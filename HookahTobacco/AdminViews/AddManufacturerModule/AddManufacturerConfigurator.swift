//
//
//  AddManufacturerConfigurator.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

class AddManufacturerConfigurator: ConfiguratorProtocol {
    
    var setNetworkManager: SetDataBaseNetworkingProtocol
    
    init(setNetworkManager: SetDataBaseNetworkingProtocol) {
        self.setNetworkManager = setNetworkManager
    }
    
    func configure() -> UIViewController {
        
        let view = AddManufacturerViewController()
        let presenter = AddManufacturerPresenter()
        let interactor = AddManufacturerInteractor(setNetworkManager: setNetworkManager)
        let router = AddManufacturerRouter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
}
