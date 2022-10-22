//
//  AddTobaccoAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import Foundation
import Swinject

class AddTobaccoAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AddTobaccoRouterProtocol.self) { (r, appAssembler: AppRouterProtocol) in
            let router = AddTobaccoRouter(appAssembler)
            return router
        }
        
        container.register(AddTobaccoInteractorInputProtocol.self) { r in
            let getDataManager = r.resolve(GetDataBaseNetworkingProtocol.self)!
            let setDataManager = r.resolve(SetDataBaseNetworkingProtocol.self)!
            return AddTobaccoInteractor(getDataManager: getDataManager,
                                        setDataManager: setDataManager)
        }
        
        container.register(AddTobaccoViewOutputProtocol.self) { r in
            let presenter = AddTobaccoPresenter()
            return presenter
        }
        
        container.register(AddTobaccoViewController.self) { (r, appAssembler: AppRouterProtocol) in
            let view = AddTobaccoViewController()
            let presenter = r.resolve(AddTobaccoViewOutputProtocol.self) as! AddTobaccoPresenter
            let interactor = r.resolve(AddTobaccoInteractorInputProtocol.self) as! AddTobaccoInteractor
            let router = r.resolve(AddTobaccoRouterProtocol.self, argument: appAssembler)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}