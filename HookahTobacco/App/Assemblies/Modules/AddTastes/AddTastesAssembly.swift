//
//
//  AddTastesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//
//

import Foundation
import Swinject

struct AddTastesDependency {
    var appRouter: AppRouterProtocol
    var selectedTastes: SelectedTastes
    var outputModule: AddTastesOutputModule?
}

class AddTastesAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AddTastesRouterProtocol.self) { (r, d: AddTastesDependency) in
            let router = AddTastesRouter(d.appRouter)
            router.outputModule = d.outputModule
            return router
        }
        
        container.register(AddTastesInteractorInputProtocol.self) { (r, d: AddTastesDependency) in
            //here resolve dependency injection
            let getDataManager = r.resolve(GetDataBaseNetworkingProtocol.self)!
            
            return AddTastesInteractor(selectedTastes: d.selectedTastes,
                                       getDataManager: getDataManager)
        }
        
        container.register(AddTastesViewOutputProtocol.self) { r in
            let presenter = AddTastesPresenter()
            return presenter
        }
        
        container.register(AddTastesViewController.self) { (r, d: AddTastesDependency) in
            let view = AddTastesViewController()
            let presenter = r.resolve(AddTastesViewOutputProtocol.self) as! AddTastesPresenter
            let interactor = r.resolve(AddTastesInteractorInputProtocol.self, argument: d) as! AddTastesInteractor
            let router = r.resolve(AddTastesRouterProtocol.self, argument: d)!
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
