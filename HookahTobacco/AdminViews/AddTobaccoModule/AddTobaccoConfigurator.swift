//
//
//  AddTobaccoConfigurator.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

class AddTobaccoConfigurator: ConfiguratorProtocol {
    private let getDataManager: GetDataBaseNetworkingProtocol
    private let setDataManager: SetDataBaseNetworkingProtocol
    
    init(getDataManager: GetDataBaseNetworkingProtocol,
         setDataManager: SetDataBaseNetworkingProtocol) {
        self.getDataManager = getDataManager
        self.setDataManager = setDataManager
    }
    
    func configure() -> UIViewController {
        
        let view = AddTobaccoViewController()
        let presenter = AddTobaccoPresenter()
        let interactor = AddTobaccoInteractor(getDataManager: getDataManager,
                                              setDataManager: setDataManager)
        let router = AddTobaccoRouter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
}
