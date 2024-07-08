//
//
//  TobaccoListModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import UIKit
import SwiftUI

struct TobaccoListDataModile: DataModuleProtocol {
    let isAdminMode: Bool
    let filter: TobaccoListInput
}

class TobaccoListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = TobaccoListDependency(appRouter: appRouter, isAdminMode: false, filter: .none)
        if let data = data as? TobaccoListDataModile {
            dependency.isAdminMode = data.isAdminMode
            dependency.filter = data.filter
        }
        let viewModel = TobaccoListViewModelImpl(
            input: dependency.filter,
            getDataNetworkingService: appRouter.resolver.resolve(GetDataNetworkingServiceProtocol.self)!,
            userService: appRouter.resolver.resolve(UserNetworkingServiceProtocol.self)!) { tobacco in
                let moduleData = DetailTobaccoDataModule(tobacco: tobacco)
                appRouter.pushViewController(
                    module: DetailTobaccoModule.self,
                    moduleData: moduleData,
                    animateDisplay: true
                )
            } showFilterTobacco: { (filters, delegate) in
                let moduleData = TobaccoFiltersDataModule(
                    filters: filters,
                    delegate: delegate
                )
                appRouter.presentViewModally(module: TobaccoFiltersModule.self, moduleData: moduleData)
            }
        let view = TobaccoListView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}
