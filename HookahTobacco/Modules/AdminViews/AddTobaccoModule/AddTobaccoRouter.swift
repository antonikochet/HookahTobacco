//
//
//  AddTobaccoRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddTobaccoRouterProtocol: RouterProtocol {
    func dismissView()
    func dismissView(with changedData: Tobacco)
}

protocol AddTobaccoOutputModule: AnyObject {
    func sendChangedTobacco(_ tobacco: Tobacco)
}

class AddTobaccoRouter: AddTobaccoRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var delegate: AddTobaccoOutputModule?
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
    
    func dismissView() {
        appRouter.popViewConroller(animated: true, completion: nil)
    }
    
    func dismissView(with changedData: Tobacco) {
        delegate?.sendChangedTobacco(changedData)
        appRouter.popViewConroller(animated: true, completion: nil)
    }
}
