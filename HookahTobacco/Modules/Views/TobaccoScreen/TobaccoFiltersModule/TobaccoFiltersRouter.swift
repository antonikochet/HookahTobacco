//
//
//  TobaccoFiltersRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import UIKit

protocol TobaccoFiltersRouterProtocol: RouterProtocol {
    func dismissView()
    func applyFiltersView(_ filters: TobaccoFilters)
}

protocol TobaccoFiltersOutputModule: AnyObject {
    func receiveFilter(_ filters: TobaccoFilters?)
}

class TobaccoFiltersRouter: TobaccoFiltersRouterProtocol {
    // MARK: - Private properties
    var appRouter: AppRouterProtocol
    weak var delegate: TobaccoFiltersOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView() {
        appRouter.dismissView(animated: true, completion: nil)
    }

    func applyFiltersView(_ filters: TobaccoFilters) {
        delegate?.receiveFilter(filters)
        appRouter.dismissView(animated: true, completion: nil)
    }
}
