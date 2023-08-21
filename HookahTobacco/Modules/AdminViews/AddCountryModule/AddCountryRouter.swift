//
//
//  AddCountryRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import UIKit

protocol AddCountryRouterProtocol: RouterProtocol {

}

protocol AddCountryOutputModule: AnyObject {
    func send(_ countries: [Country])
}

class AddCountryRouter: AddCountryRouterProtocol {
    // MARK: - Private properties
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
}
