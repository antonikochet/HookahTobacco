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
        
        container.register(AddTobaccoRouterInputProtocol.self) { (r, appAssembler: AppAssemblerProtocol, viewController: AddTobaccoViewController) in
            let router = AddTobaccoRouter(appAssembler, viewController)
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
        
        container.register(AddTobaccoViewController.self) { (r, appAssembler: AppAssemblerProtocol) in
            let view = AddTobaccoViewController()
            let presenter = r.resolve(AddTobaccoViewOutputProtocol.self) as! AddTobaccoPresenter
            let interactor = r.resolve(AddTobaccoInteractorInputProtocol.self) as! AddTobaccoInteractor
            let router = r.resolve(AddTobaccoRouterInputProtocol.self, arguments: appAssembler, view)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
