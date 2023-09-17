//
//
//  SelectListBottomSheetModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import UIKit

struct SelectListBottomSheetDataModule: DataModuleProtocol {
    let title: String?
    let items: [String]
    let selectedIndex: Int?
    let output: SelectListBottomSheetOutputModule?
}

class SelectListBottomSheetModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = SelectListBottomSheetDependency(appRouter: appRouter, items: [])
        if let data = data as? SelectListBottomSheetDataModule {
            dependency.title = data.title
            dependency.items = data.items
            dependency.selectedIndex = data.selectedIndex
            dependency.output = data.output
        }
        return appRouter.resolver.resolve(SelectListBottomSheetViewController.self,
                                          argument: dependency)
    }
}
