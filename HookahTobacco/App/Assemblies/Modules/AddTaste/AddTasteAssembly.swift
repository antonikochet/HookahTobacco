//
//
//  AddTasteAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation
import Swinject

struct AddTasteDependency {
    var appRouter: AppRouterProtocol
    var taste: Taste?
    var allIdsTaste: Set<Int>
    var outputModule: AddTasteOutputModule?
}

class AddTasteAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AddTasteRouterProtocol.self) { (r, d: AddTasteDependency) in
            let router = AddTasteRouter(d.appRouter)
            router.outputModule = d.outputModule
            return router
        }
        
        container.register(AddTasteInteractorInputProtocol.self) { (r, d: AddTasteDependency) in
            //here resolve dependency injection
            let setDataManager = r.resolve(SetDataNetworkingServiceProtocol.self)!
            
            return AddTasteInteractor(d.taste,
                                      allIdsTaste: d.allIdsTaste,
                                      setDataManager: setDataManager)
        }
        
        container.register(AddTasteViewOutputProtocol.self) { r in
            let presenter = AddTastePresenter()
            return presenter
        }
        
        container.register(AddTasteViewController.self) { (r, d: AddTasteDependency) in
            let view = AddTasteViewController()
            let presenter = r.resolve(AddTasteViewOutputProtocol.self) as! AddTastePresenter
            let interactor = r.resolve(AddTasteInteractorInputProtocol.self, argument: d) as! AddTasteInteractor
            let router = r.resolve(AddTasteRouterProtocol.self, argument: d) as! AddTasteRouter
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            presenter.router = router
            return view
        }
    }
}
